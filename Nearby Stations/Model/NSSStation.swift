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
final class NSSStation: Hashable, Equatable, Identifiable, ObservableObject {

    static func == (lhs: NSSStation, rhs: NSSStation) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    private static let defaultID: UUID = UUID(uuid: (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0))

    public static let `default`: NSSStation = .init(delegate: .shared)

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

    public var artwork: Data?

    init(
        location: CLLocation? = nil,
        delegate: NSSStationManagerDelegate? = nil
    ) {
        Logger.station.debug("willInitNSSStation")
        self.id = NSSStation.defaultID
        self.name = NSSStorage.shared.myStationName
        self.location = location
        self.delegate = delegate
        DispatchQueue.main.async {
            Task {
                if let musicID = NSSMusic.getCurrentSongId() {
                    self.musicID = musicID
                    do {
                        self.song = try await NSSMusic.getSongFrom(string: musicID)
                    } catch {
                        Logger.station.error("\(error.localizedDescription)")
                    }
                }
                self.delegate?.manager(self, didInit: self)
            }
        }
    }

    init(
        name: String,
        musicID: String,
        location: CLLocation,
        delegate: NSSStationManagerDelegate? = nil
    ) {
        Logger.station.debug("willInitStation")
        self.id = UUID()
        self.name = name
        self.location = location
        self.musicID = musicID
        self.delegate = delegate
        DispatchQueue.main.async {
            Task {
                do {
                    self.song = try await NSSMusic.getSongFrom(string: musicID)
                } catch {
                    print(error.localizedDescription)
                }
                self.delegate?.manager(self, didInit: self)
            }
        }
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
        Logger.station.debug("willInitStation")
        self.id = UUID()
        self.name = name
        self.location = location
        self.musicID = song.id.rawValue
        self.song = song
        self.delegate = delegate
        self.delegate?.manager(self, didInit: self)
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

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
        hasher.combine(self.serviceID)
        hasher.combine(self.deviceID)
    }

    func updateSong() async {
        if let musicID = self.musicID {
            do {
                self.song = try await NSSMusic.getSongFrom(string: musicID)
            } catch {
                print(error.localizedDescription)
            }
        }
        self.delegate?.manager(self, didUpdateSong: self.song)
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
