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

@Observable
final class NSSStation: NSObject, Identifiable {

    private static let defaultID: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))

    public static let `default`: NSSStation = .init(delegate: .shared)

    public static var focused: NSSStation? {
        NSSModel.shared.focused
    }

    public static var listened: NSSStation? {
        NSSModel.shared.listened
    }

    public var delegate: NSSStationManagerDelegate?

    public let id: UUID
    public var serviceID: String? = UUID().uuidString
    public var deviceID: String? = UUID().uuidString
    public var name: String {
        willSet {
            self.delegate?.manager(self, willSetName: newValue)
        }
        didSet {
            self.delegate?.manager(self, didSetName: oldValue)
        }
    }
    public var musicID: String? {
        willSet {
            self.delegate?.manager(self, willSetMusicID: newValue)
        }
        didSet {
            self.delegate?.manager(self, didSetMusicID: oldValue)
        }
    }
    public var song: Song? {
        willSet {
            self.delegate?.manager(self, willSetSong: newValue)
        }
        didSet {
            self.delegate?.manager(self, didSetSong: oldValue)
        }
    }
    public var location: CLLocation? {
        willSet {
            self.delegate?.manager(self, willSetLocation: newValue)
        }
        didSet {
            self.delegate?.manager(self, didSetLocation: oldValue)
        }
    }
    public var listeners: Int = 0 {
        willSet {
            self.delegate?.manager(self, willSetListeners: newValue)
        }
        didSet {
            self.delegate?.manager(self, didSetListeners: oldValue)
        }
    }
    public var open: Bool = false {
        willSet {
            self.delegate?.manager(self, willSetOpen: newValue)
        }
        didSet {
            self.delegate?.manager(self, didSetOpen: oldValue)
        }
    }
    public var artwork: Data? {
        willSet {
            self.delegate?.manager(self, willSetArtwork: newValue)
        }
        didSet {
            self.delegate?.manager(self, didSetArtwork: oldValue)
        }
    }

    init(
        location: CLLocation? = nil,
        delegate: NSSStationManagerDelegate? = nil
    ) {
        self.id = NSSStation.defaultID
        self.name = NSSStorage.shared.myStationName
        super.init()
        Logger.station.debug(" willInit - self: \(String(describing: self))")
        delegate?.manager(self, willInit: self)
        self.location = location
        self.delegate = delegate
        self.addObservers()
        if let musicID = NSSMusic.getCurrentSongId() {
            self.musicID = musicID
            Task {
                await NSSMusic.getSongFrom(string: musicID)
            }
        }
        self.delegate?.manager(self, didInit: self)
        Logger.station.debug(" didInit - self: \(String(describing: self))")
    }

    init(
        name: String,
        musicID: String,
        location: CLLocation,
        delegate: NSSStationManagerDelegate?
    ) {
        self.id = UUID()
        self.name = name
        super.init()
        Logger.station.debug(" willInit - self: \(String(describing: self))")
        delegate?.manager(self, willInit: self)
        self.location = location
        self.musicID = musicID
        self.delegate = delegate
        Task {
            self.song = await NSSMusic.getSongFrom(string: musicID)
        }
        self.delegate?.manager(self, didInit: self)
        Logger.station.debug(" didInit - self: \(String(describing: self))")
    }

    convenience init(
        name: String,
        musicID: String,
        location: CLLocationCoordinate2D,
        delegate: NSSStationManagerDelegate? = nil
    ) {
        self.init(
            name: name,
            musicID: musicID,
            location: CLLocation(latitude: location.latitude, longitude: location.longitude),
            delegate: delegate
        )
    }

    init(
        name: String,
        song: Song,
        location: CLLocation,
        delegate: NSSStationManagerDelegate? = .shared
    ) {
        self.id = UUID()
        self.name = name
        super.init()
        Logger.station.debug(" willInit - self: \(String(describing: self))")
        delegate?.manager(self, willInit: self)
        self.delegate = delegate
        self.location = location
        self.musicID = song.id.rawValue
        self.song = song
        self.delegate?.manager(self, didInit: self)
        Logger.station.debug(" willInit - self: \(String(describing: self))")
    }

    convenience init(
        name: String,
        song: Song,
        location: CLLocationCoordinate2D,
        delegate: NSSStationManagerDelegate? = nil
    ) {
        self.init(
            name: name,
            song: song,
            location: CLLocation(latitude: location.latitude, longitude: location.longitude),
            delegate: delegate
        )
    }

    func updateSong() async {
        Task {
            if let musicID = self.musicID {
                self.song = await NSSMusic.getSongFrom(string: musicID)
            }
            self.delegate?.manager(self, didUpdateSong: self.song)
        }
    }

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
            object: NSSMap.shared
        )
    }
}
