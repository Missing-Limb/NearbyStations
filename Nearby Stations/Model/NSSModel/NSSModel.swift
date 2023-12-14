//
//  Model.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 07/12/23.
//

import SwiftUI
import CoreLocation
import Collections
import OSLog

@Observable
class NSSModel: ObservableObject {

    public static let shared: NSSModel = .init(delegate: .default)

    public var map: NSSMap     = .init(delegate: .default)
    public var music: NSSMusic   = .init(delegate: .default)
    public var storage: NSSStorage = .init(delegate: .default)

    public var style: NSSStyle    = .init()
    public var tips: NSSTips     = .init()

    public var delegate: NSSModelManagerDelegate? {
        willSet {
            self.delegate?.manager(self, willSetDelegate: newValue)
        }
        didSet {
            self.delegate?.manager(self, didSetDelegate: oldValue)
        }
    }

    internal var isMusicAccessible: Bool = false {
        willSet {
            self.delegate?.manager(self, willSetMusicAccessStatus: newValue)
        }
        didSet {
            self.delegate?.manager(self, didSetMusicAccessStatus: oldValue)
        }
    }

    internal var isLocationAccessible: Bool = false {
        willSet {
            self.delegate?.manager(self, willSetLocationAccessStatus: newValue)
        }
        didSet {
            self.delegate?.manager(self, didSetLocationAccessStatus: oldValue)
        }
    }

    internal var areStationsInitialized: Bool = false {
        willSet {
            self.delegate?.manager(self, willSetStationsInitializationStatus: newValue)
        }
        didSet {
            self.delegate?.manager(self, didSetStationsInitializationStatus: oldValue)
        }
    }

    public var scrollViewProxy: ScrollViewProxy? {
        willSet {
            self.delegate?.manager(self, willSetScrollViewProxy: newValue)
        }
        didSet {
            self.delegate?.manager(self, didSetScrollViewProxy: oldValue)
        }
    }

    public var isFollowingUser: Bool = true {
        willSet {
            self.delegate?.manager(self, willSetFollowingUserStatus: newValue)
        }
        didSet {
            self.delegate?.manager(self, didSetFollowingUserStatus: oldValue)
        }
    }

    public var isBroadcasting: Bool = false {
        willSet {
            self.delegate?.manager(self, willSetBroadcastingStatus: newValue)
        }
        didSet {
            self.delegate?.manager(self, didSetBroadcastingStatus: oldValue)
        }
    }

    public var isLiveListening: Bool = false {
        willSet {
            self.delegate?.manager(self, willSetLiveListeningStatus: newValue)
        }
        didSet {
            self.delegate?.manager(self, didSetLiveListeningStatus: oldValue)
        }
    }

    public var listened: NSSStation? = NSSStation.default {
        willSet {
            self.delegate?.manager(self, willSetListened: newValue)
        }
        didSet {
            self.delegate?.manager(self, willSetListened: oldValue)
        }
    }

    public var listenedID: UUID? {
        get {
            return self.listened?.id
        }
        set {
            self.listened = self.allStations.first(where: { $0.id == newValue })
        }
    }

    public var isPlaying: Bool = false {
        willSet {
            self.delegate?.manager(self, willSetPlayingStatus: newValue)
        }
        didSet {
            self.delegate?.manager(self, didSetPlayingStatus: oldValue)
        }
    }

    public var focused: NSSStation? = NSSStation.default {
        willSet {
            self.delegate?.manager(self, willSetFocused: newValue)
        }
        didSet {
            self.delegate?.manager(self, didSetFocused: oldValue)
        }
    }

    public var focusedID: UUID? {
        get {
            return self.focused?.id
        }
        set {
            self.focused = self.allStations.first(where: { $0.id == newValue })
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

    public var stations: Set<NSSStation> = [] {
        willSet {
            self.delegate?.manager(self, willSetStations: newValue)
        }
        didSet {
            self.delegate?.manager(self, didSetStations: oldValue)
        }
    }

    public var allStations: OrderedSet<NSSStation> {
        let stations = OrderedSet<NSSStation>(self.stations).union([NSSStation.default])
        self.delegate?.manager(self, didComputeAllStations: stations)
        return stations
    }

    public var sortedStations: Deque<NSSStation> = [] {
        willSet {
            self.delegate?.manager(self, willSetSortedStations: newValue)
        }
        didSet {
            self.delegate?.manager(self, didSetSortedStations: oldValue)
        }
    }

    init(delegate: NSSModelManagerDelegate? = nil) {
        Logger.model.debug("willInitNSSModel")
        self.delegate = delegate
        self.delegate?.manager(self, didInit: self)
    }

    private func move(
        to location: CLLocation,
        latitudinalMeters: CLLocationDistance = 200,
        longitudinalMeters: CLLocationDistance = 200
    ) {
        self.move(
            to: location.coordinate,
            latitudinalMeters: latitudinalMeters,
            longitudinalMeters: longitudinalMeters
        )
    }

    private func move(
        to coordinate: CLLocationCoordinate2D,
        latitudinalMeters: CLLocationDistance = 200,
        longitudinalMeters: CLLocationDistance = 200
    ) {
        DispatchQueue.main.async {
            withAnimation {
                self.map.cameraPosition = .region(.init(
                    center: coordinate,
                    latitudinalMeters: latitudinalMeters,
                    longitudinalMeters: longitudinalMeters
                ))
            }
        }
    }

    private func move(
        to station: NSSStation?,
        latitudinalMeters: CLLocationDistance = 200,
        longitudinalMeters: CLLocationDistance = 200
    ) {
        guard station != nil || station != NSSStation.default else {
            self.isFollowingUser = true
            return
        }
        if let location = station!.location {
            self.move(
                to: location,
                latitudinalMeters: latitudinalMeters,
                longitudinalMeters: longitudinalMeters
            )
        }
    }

    private func scroll(to id: UUID?) {
        if let proxy = self.scrollViewProxy {
            proxy.scrollTo(id, anchor: .center)
        }
    }

    private func scroll(to station: NSSStation?) {
        self.scroll(to: station?.id ?? NSSStation.default.id)
    }

    public func updateScrollPosition() {
        self.scroll(to: self.focused)
    }

    public func updateMapCameraPosition() {
        self.move(to: self.focused)
    }

    public func updateListenedStation() {
        if let listened = self.listened,
           !self.sortedStations.contains(listened),
           self.isLiveListening {
            self.listened = self.sortedStations.firstDifferent ?? NSSStation.default
        }
    }

    public func updateStationsInformation() {
        DispatchQueue.main.async {
            for station in self.stations {
                Task {
                    await station.updateSong()
                }
            }
        }
    }

    public func updateFocusedStation() {
        if let focused = self.focused, !self.sortedStations.contains(focused) {
            self.focused = NSSStation.default
        }
    }

    public func getClosestStations(
        to location: CLLocation?
    ) -> Deque<NSSStation> {
        return if location != nil {
            .init(self.stations.sorted(by: { (lhs, rhs) in
                return if let lhd = lhs.distance(from: location), let rhd = rhs.distance(from: location) {
                    lhd < rhd
                } else {
                    false
                }
            }))
        } else {
            .init(self.stations)
        }
    }

    public func getAllClosestStations(
        to location: CLLocation?
    ) -> Deque<NSSStation> {
        var stations: Deque<NSSStation> = self.getClosestStations(to: location)
        stations.prepend(NSSStation.default)
        return stations
    }
}
