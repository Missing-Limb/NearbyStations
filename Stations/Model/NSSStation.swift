//
//  Station.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 07/12/23.
//

import SwiftUI
import OSLog
import MapKit
import MusicKit
import CloudKit

@Observable
final class NSSStation: NSObject, Identifiable, Sendable {
    public static func isEqual(lhs: NSSStation, rhs: NSSStation) -> Bool {
        lhs.id == rhs.id
    }

    private static let defaultID: UUID = UUID(uuidString: NSSStorage.shared.myID)!
    public static let `default`: NSSStation = .init()

    public static var focused: NSSStation? {
        NSSModel.shared.focused
    }
    public static var listened: NSSStation? {
        NSSModel.shared.listened
    }

    public let id: UUID
    public var name: String = ""
    public var location: CLLocation?
    public var listeners: Int = 0
    public var open: Bool = false
    public var artwork: UIImage?
    public var playbackTime: TimeInterval?
    public var saveTime: TimeInterval?

    public private(set) var song: Song? {
        didSet {
            if let song = self.song {
                Task {
                    if let data = await NSSMusic.getSongArtworkFrom(song: self.song) {
                        self.artwork = UIImage(data: data)
                    }
                }
            }
        }
    }

    public var playbackDuration: TimeInterval? {
        self.song?.duration
    }
    public var musicID: String? {
        self.song?.id.rawValue
    }
    public var musicItemID: MusicItemID? {
        self.song?.id
    }

    init(location: CLLocation? = nil) {
        self.id = NSSStation.defaultID
        self.name = NSSStorage.shared.myStationName
        super.init()
        Task {
            self.song = await NSSMusic.shared.nowPlayingSong()
        }
        self.location = location
        self.addObservers()
    }

    init(id: String? = nil, name: String, song: Song?, location: CLLocation) {
        self.id = id != nil ? UUID(uuidString: id!)! : UUID()
        self.name = name
        self.song = song
        super.init()
        self.location = location
    }

    init(from record: CKRecord) async {
        let id: UUID = UUID(uuidString: (record["identifier"] as! String))!
        let location: CLLocation = record["location"] as! CLLocation
        // MARK: Real Initialization
        self.id = id
        self.location = location
        super.init()

        self.song = await Task {
            if let nssSong = await NSSCloud.getStationSongBy(id: id.uuidString) {
                self.playbackTime = nssSong.playbackTime
                self.saveTime = nssSong.saveTime
                return await NSSMusic.getSongFrom(string: nssSong.id)
            } else {
                return nil
            }
        }.value

        self.name = await Task {
            await NSSCloud.getStationNameBy(id: id.uuidString) ?? ""
        }.value
    }

    init(name: String, from nssSong: NSSSong, location: CLLocation) {
        self.id = .init()
        self.name = name
        self.location = location
        super.init()
        Task {
            self.song = await NSSMusic.getSongFrom(string: nssSong.id)
        }
        self.playbackTime = nssSong.playbackTime
        self.saveTime = nssSong.saveTime
    }

    @discardableResult
    public func updateSong() async -> Bool {
        if self == .default {
            if let song = await NSSMusic.shared.nowPlayingSong() {
                self.song = song
            }
        } else {
            if let nssSong = await NSSCloud.getStationSongBy(id: self.id) {
                self.playbackTime = nssSong.playbackTime
                self.saveTime = nssSong.saveTime
                if let song = await NSSMusic.getSongFrom(string: nssSong.id) {
                    self.song = song
                }
            }
        }
        return self.song != nil
    }

    @discardableResult
    public func updateArtwork(force: Bool = false) async -> Bool {
        if !force && self == NSSStation.default {
            if let playerEntry = NSSMusic.shared.nowPlayingEntry,
               let artwork = playerEntry.artwork {
                let width = artwork.maximumWidth
                let height = artwork.maximumHeight
                if let data = await NSSMusic.getSongArtworkFrom(url: artwork.url(width: width, height: height)) {
                    self.artwork = UIImage(data: data)
                    return true
                }
            }
            return false
        } else {
            if let song = self.song {
                if let data = await NSSMusic.getSongArtworkFrom(song: song) {
                    self.artwork = UIImage(data: data)
                    return true
                }
            }
        }
        return false
    }

    @discardableResult
    public func updateName() async -> Bool {
        self.name = await NSSCloud.getStationNameBy(id: self.id) ?? self.name
        return self.name != ""
    }

    @discardableResult
    public func updateListeners() async -> Bool {
        self.listeners = await NSSCloud.getStationListenersBy(id: self.id) ?? self.listeners
        return self.listeners >= 0
    }

    @discardableResult
    public func update() async -> Bool {
        return await Task {
            #if DEBUG
            return self.song != nil ? await self.updateSong() : false
            #else
            if self == NSSStation.default {
                return self.song != nil ? await self.updateSong() : false
            } else {
                do {
                    return try await withThrowingTaskGroup(of: Bool.self) { group in
                        group.addTask { await self.updateLocation() }
                        group.addTask { await self.updateName() }
                        group.addTask { await self.updateListeners() }
                        var results: Bool = true
                        for try await result in group { results = results && result }
                        return result
                    }
                } catch {
                    Logger.station.error("\(error.localizedDescription)")
                }
                return false
            }
            #endif
        }.value
    }

    @discardableResult
    public func changeSong(
        to song: Song?,
        at playbackTime: TimeInterval? = 0,
        savedAt saveTime: TimeInterval? = -1
    ) async -> Bool {
        if let song = song {
            self.song = song
            self.playbackTime = playbackTime
            self.saveTime = saveTime
            return self.song != nil && self.song == song
        }
        return false
    }

    @discardableResult
    public func changeSong(
        to entry: MusicPlayer.Queue.Entry?,
        at playbackTime: TimeInterval,
        savedAt saveTime: TimeInterval
    ) async -> Bool {
        if let entry = entry {
            if let item = entry.item {
                let id = item.id
                if let song = await NSSMusic.getSongFrom(musicItemID: id) {
                    self.song = song
                    return self.song != nil && self.song == song
                }
            }
        }
        return false
    }

}

extension NSSStation {
    func distance(from otherLocation: CLLocation? = nil) -> CLLocationDistance? {
        return if otherLocation != nil, let location = self.location {
            location.distance(from: otherLocation!)
        } else {
            nil
        }
    }
    func distance(from otherStation: NSSStation) -> CLLocationDistance? {
        return if let other = otherStation.location {
            self.distance(from: other)
        } else {
            nil
        }
    }
}

extension NSSStation {

    @objc func updateLocation() {
        self.location = NSSMap.location
    }

    private func addObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateLocation),
            name: .locationUpdate,
            object: nil
        )
    }

    private func removeObservers() {
        NotificationCenter.default.removeObserver(
            self,
            name: .locationUpdate,
            object: nil
        )
    }
}
