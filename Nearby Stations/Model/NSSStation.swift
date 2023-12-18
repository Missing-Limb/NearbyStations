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
final class NSSStation: NSObject, Identifiable {
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
    public let deviceID: String? = UIDevice.current.identifierForVendor?.uuidString
    public var name: String
    public var location: CLLocation?
    public var listeners: Int = 0
    public var open: Bool = false

    public private(set) var song: NSSSong?

    public var artwork: UIImage? {
        self.song?.artwork
    }
    public var playbackDuration: TimeInterval? {
        self.song?.playbackDuration
    }
    public var playbackTime: TimeInterval? {
        get {
            self.song?.playbackTime
        }
        set {
            self.song?.setPlaybackTime(to: newValue!)
        }
    }
    public var musicID: String? {
        self.song?.id
    }

    init(location: CLLocation? = nil) {
        self.id = NSSStation.defaultID
        self.name = NSSStorage.shared.myStationName
        self.song = NSSSong.now
        super.init()
        self.location = location
        self.addObservers()
    }

    init(id: String? = nil, name: String, song: NSSSong, location: CLLocation) {
        self.id = id != nil ? UUID(uuidString: id!)! : UUID()
        self.name = name
        self.song = song
        super.init()
        self.location = location
    }

    init(from record: CKRecord) {

        let id: UUID = UUID(uuidString: (record["identifier"] as! String))!
        let name: String = (record["name"] as! String)
        let playbackTime: TimeInterval? = (record["playbackTime"] as! TimeInterval)
        let saveTime: TimeInterval? = (record["saveTime"] as! TimeInterval)
        let song: NSSSong = .init(
            from: (record["songIdentifier"] as! String),
            at: playbackTime,
            savedAt: saveTime
        )
        let location: CLLocation = record["location"] as! CLLocation

        // MARK: Real Initialization
        self.id = id
        self.name = name
        self.song = song
        self.location = location
    }

    @discardableResult
    public func updateSong() async -> Bool {
        await Task { await self.song?.updateSong() }.value ?? false
    }

    @discardableResult
    public func updateImage() async -> Bool {
        await Task { await self.song?.updateImage() }.value ?? false
    }

    @discardableResult
    public func updateInformations() async -> Bool {
        await Task { await self.song?.update() }.value ?? false
    }

    @discardableResult
    public func update() async -> Bool {
        return await Task {
            #if DEBUG
            return self.song != nil ? await self.song!.update() : false
            #else
            if self == NSSStation.default {
                return self.song != nil ? await self.song!.update() : false
            } else {
                self.song = await NSSCloud.getStationSongBy(id: self.id.uuidString)
                return await self.song?.update() ?? false
            }
            #endif
        }.value
    }

    @discardableResult
    public func changeSong(to song: NSSSong) async -> Bool {
        self.song = song
        return await Task { await self.update() }.value
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
