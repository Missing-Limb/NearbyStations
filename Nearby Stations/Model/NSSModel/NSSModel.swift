//
//  Model.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 07/12/23.
//

import SwiftUI
import CoreLocation
import Collections
import _MapKit_SwiftUI
import OSLog

@Observable
final class NSSModel: NSObject {

    public static let shared: NSSModel = .init()

    private let center: NotificationCenter = NotificationCenter.default

    internal var areStationsInitializable: Bool = false
    internal var areStationsInitialized: Bool = false

    public var scrollViewProxy: ScrollViewProxy?

    public var isFollowingUser: Bool = true {
        didSet {
            self.updateFollowingUserState()
        }
    }

    public var isBroadcasting: Bool = false {
        didSet {
            self.updateBroadcastingState()
        }
    }

    public var isLiveListening: Bool = false {
        didSet {
            self.updateLiveListeningState()
        }
    }

    public var location: CLLocation? {
        didSet {
            self.center.post(name: .locationUpdated, object: nil)
        }
    }

    public var focused: NSSStation? = NSSStation.default {
        didSet {
            self.center.post(name: .focusUpdate, object: nil)
        }
    }

    public var focusedID: UUID? {
        get {
            self.focused?.id
        }
        set {
            self.focused = self.allStations.first(where: { $0.id == newValue })
            self.center.post(name: .focusUpdate, object: nil)
        }
    }

    public var listened: NSSStation? = NSSStation.default

    public var listenedID: UUID? {
        get {
            return self.listened?.id
        }
        set {
            self.listened = self.stations?.first(where: { $0.id == newValue }) ?? NSSStation.default
        }
    }

    public var isPlaying: Bool = false

    public var stations: Set<NSSStation>? {
        didSet {
            if !self.areStationsInitialized {
                self.center.post(name: .stationsInitialized, object: nil)
                self.areStationsInitialized.toggle()
            } else {
                self.center.post(name: .stationsUpdated, object: nil)
            }
        }
    }

    public var allStations: Set<NSSStation> {
        stations != nil ? stations!.union([.default]) : [.default]
    }

    public var closestStations: Deque<NSSStation> = []

    public var allClosestStations: Deque<NSSStation> {
        var closestStations = self.closestStations
        closestStations.prepend(.default)
        return closestStations
    }

    override private init() {
        super.init()
        self.addObservers()
    }

    deinit {
        self.removeObservers()
    }
}

// MARK: Notifications Observers
extension NSSModel {

    @objc private func updateAccess() {
        if NSSMusic.authorized && NSSMap.authorized {
            self.areStationsInitializable = true
            self.center.post(name: .accessGranted, object: nil)
        }
    }

    @objc private func initializeStations() {
        #if DEBUG
        self.stations = .init(PreviewStations.defaultStations)
        #else
        self.stations = .init()
        #endif
    }

    @objc private func updateLocation() {
        if let location = NSSMap.location {
            self.location = location
        }
    }

    @objc private func updateCamera() {
        self.isFollowingUser = NSSMap.cameraPosition.followsUserLocation
    }

    @objc private func updateFocus() {
        self.closePreviouslyFocusedStation()
        self.moveCamera(to: .focused)
    }

    @objc private func updateStationsInformation() {
        if let stations = self.stations {
            for station in stations {
                Task {
                    await station.updateSong()
                }
            }
        }
    }

    @objc private func updateClosestStations() {
        self.closestStations = self.getClosestStations(to: self.location)
    }

    private func addObservers() {
        self.center.addObserver(
            self,
            selector: #selector(updateAccess),
            name: .accessUpdate, object: nil
        )
        self.center.addObserver(
            self,
            selector: #selector(initializeStations),
            name: .accessGranted, object: nil
        )
        self.center.addObserver(
            self,
            selector: #selector(updateLocation),
            name: .locationUpdate, object: nil
        )
        self.center.addObserver(
            self,
            selector: #selector(updateCamera),
            name: .cameraUpdate, object: nil
        )
        self.center.addObserver(
            self,
            selector: #selector(updateFocus),
            name: .focusUpdate, object: nil
        )
        self.center.addObserver(
            self,
            selector: #selector(updateStationsInformation),
            name: .stationsInitialized, object: nil
        )
        self.center.addObserver(
            self,
            selector: #selector(updateClosestStations),
            name: .stationsInitialized, object: nil
        )
        self.center.addObserver(
            self,
            selector: #selector(updateStationsInformation),
            name: .stationsUpdated, object: nil
        )
        self.center.addObserver(
            self,
            selector: #selector(updateClosestStations),
            name: .stationsUpdated, object: nil
        )
        self.center.addObserver(
            self,
            selector: #selector(updateClosestStations),
            name: .locationUpdated, object: nil
        )
    }

    private func removeObservers() {
        self.center.removeObserver(self, name: .accessUpdate, object: nil)
        self.center.removeObserver(self, name: .accessGranted, object: nil)
        self.center.removeObserver(self, name: .locationUpdate, object: nil)
        self.center.removeObserver(self, name: .cameraUpdate, object: nil)
        self.center.removeObserver(self, name: .focusUpdate, object: nil)
        self.center.removeObserver(self, name: .stationsInitialized, object: nil)
        self.center.removeObserver(self, name: .stationsInitialized, object: nil)
        self.center.removeObserver(self, name: .stationsUpdated, object: nil)
        self.center.removeObserver(self, name: .stationsUpdated, object: nil)
    }
}

// MARK: Stations Operations
extension NSSModel {

    private func getClosestStations(to location: CLLocation?) -> Deque<NSSStation> {
        guard let stations = self.stations else {
            return .init()
        }

        guard let location = location else {
            return .init(stations)
        }

        return .init(stations.sorted(relativeTo: location))
    }

    private func getAllClosestStations(to location: CLLocation?) -> Deque<NSSStation> {
        var stations = self.getClosestStations(to: location)
        stations.prepend(.default)
        return stations
    }

}

// MARK: Update Stations State

extension NSSModel {

    private func updateFollowingUserState() {
        if self.isFollowingUser {
            self.moveCamera(to: .user)
        } else {
            if NSSMap.cameraPosition == .userLocation(followsHeading: true, fallback: .automatic) {
                self.moveCamera(to: .user, followsHeading: false)
            }
        }
    }

}

// MARK: Update Listened Station
extension NSSModel {

    /// Set the listened station user station based on the currently playing third-party station and copy the music from the latter into user station
    /// - Parameter source: Third-Party station used to copy its song to user station
    public func updateListenedStation(from source: NSSStation?) {
        guard let source = source, source != NSSStation.default else {
            Logger.model.info("No Source Station.")
            return
        }

        NSSStation.default.musicID = source.musicID

        self.updateListenedStation(to: .default, withFocus: true)
    }

    /// Set the listened station to the target station if the local list of stations contains the target station
    /// - Parameters:
    ///   - target: Target station to play
    ///   - focus: Decide to set the focus on this station or not
    public func updateListenedStation(to target: NSSStation?, withFocus focus: Bool = false) {
        let target: NSSStation = target != nil
            ? self.allStations.contains(target!)
            ? target!
            : self.closestStations.firstDifferent ?? .default
            : .default
        Task {
            DispatchQueue.main.async {
                withAnimation {
                    if focus {
                        self.focused = target
                    }
                    self.listened = target
                } completion: {
                    Task {
                        await self.play(station: target)
                    }
                }
            }
            return
        }
    }

    public func updateListenedStation(withFocus focus: Bool = false) {
        let listened: NSSStation = self.listened != nil
            ? self.allStations.contains(self.listened!)
            ? self.listened!
            : self.closestStations.firstDifferent ?? .default
            : .default
        DispatchQueue.main.async {
            withAnimation {
                if focus {
                    self.focused = listened
                }
                self.listened = listened
            } completion: {
                Task {
                    await self.play(station: listened)
                }
            }
        }
    }

    private func updateBroadcastingState() {
        if self.isBroadcasting {
            self.isLiveListening = false
            self.updateListenedStation(from: self.focused)
        }
    }

    private func updateLiveListeningState() {
        if self.isLiveListening {
            self.isBroadcasting = false
            self.updateListenedStation(to: self.closestStations.first, withFocus: true)
        }
    }

}

extension NSSModel {

    public func closePreviouslyFocusedStation() {
        if let focused = self.focused, let station = self.allStations.open(differentFrom: focused) {
            withAnimation {
                station.open = false
            }
        }
    }
}

extension NSSModel {

    public func updateFocusedStation() {
        guard let focused = self.focused, let stations = self.stations else {
            self.focused = .default
            return
        }

        self.focused = stations.contains(focused)
            ? focused
            : .default
    }

}
