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
    internal var shouldAskPermissions: Bool {
        !self.areStationsInitializable
    }

    public var scrollViewProxy: ScrollViewProxy?

    public var isFollowingUser: Bool = true {
        didSet {
            updateFollowingUserState()
        }
    }

    public var isBroadcasting: Bool = false {
        didSet {
            updateBroadcastingState()
        }
    }

    public var isLiveListening: Bool = false {
        didSet {
            updateLiveListeningState()
        }
    }

    public var location: CLLocation? {
        didSet {
            center.post(name: .locationUpdated, object: nil)
        }
    }

    public var focused: NSSStation? = NSSStation.default {
        didSet {
            center.post(name: .focusUpdate, object: nil)
        }
    }

    public var focusedID: UUID? {
        get {
            focused?.id
        }
        set {
            focused = allStations.first(where: { $0.id == newValue })
            center.post(name: .focusUpdate, object: nil)
        }
    }

    public var listened: NSSStation? = NSSStation.default

    public var listenedID: UUID? {
        get {
            return self.listened?.id
        }
        set {
            self.listened = stations?.first(where: { $0.id == newValue }) ?? .default
        }
    }

    public var isPlaying: Bool = false

    public var stations: Set<NSSStation>? {
        didSet {
            if !areStationsInitialized {
                center.post(name: .stationsInitialized, object: nil)
                areStationsInitialized.toggle()
            } else {
                center.post(name: .stationsUpdated, object: nil)
            }
        }
    }

    public var allStations: Set<NSSStation> {
        stations != nil ? stations!.union([.default]) : [.default]
    }

    public var closestStations: Deque<NSSStation> = [] {
        didSet {
            if isLiveListening {
                if let first = self.closestStations.first,
                   let listened = self.listened {
                    if listened.song?.id.rawValue != first.song?.id.rawValue {
                        self.updateListenedStation(to: self.closestStations.first, withFocus: true)
                    }
                }
            }
        }
    }

    public var allClosestStations: Deque<NSSStation> {
        var closestStations = closestStations
        closestStations.prepend(.default)
        return closestStations
    }

    override private init() {
        super.init()
        addObservers()
    }

    deinit {
        removeObservers()
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
                    await station.update()
                }
            }
        }
    }

    @objc private func updateClosestStations() {
        self.closestStations = self.getClosestStations(to: self.location)
    }

    @objc private func updateStations() {
        self.stations = NSSCloud.shared.stations
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

    public func updatePlayingStatus() {
        if isPlaying {
            if listened != focused {
                updateListenedStation(to: focused, withFocus: true)
            } else {
                isPlaying = false
                pause()
            }
        } else {
            if listened != focused {
                updateListenedStation(to: focused, withFocus: true)
            } else {
                updateListenedStation(to: focused)
            }
            isPlaying = true
            updateListenedStation(to: focused, withFocus: true)

        }
    }

    /// Set the listened station user station based on the currently playing third-party station and copy the music from the latter into user station
    /// - Parameter source: Third-Party station used to copy its song to user station
    public func updateListenedStation(from source: NSSStation?) {
        guard let source = source, source != NSSStation.default else {
            Logger.model.info("No Source Station.")
            return
        }
        Task {
            if source.musicID != nil {
                await NSSStation.default.changeSong(
                    to: source.song,
                    at: source.playbackTime,
                    savedAt: source.saveTime
                )
                self.updateListenedStation(to: .default, withFocus: true)
            }
        }
    }

    /// Set the listened station to the target station if the local list of stations contains the target station
    /// - Parameters:
    ///   - target: Target station to play
    ///   - focus: Decide to set the focus on this station or not
    /// - Returns: Focused station
    @discardableResult
    public func updateListenedStation(to target: NSSStation?, withFocus focus: Bool = false) -> NSSStation {
        let closest = self.closestStations.firstDifferent
        let target: NSSStation = target != nil
            ? self.allStations.contains(target!)
            ? target!
            : closest ?? .default
            : .default
        if target != .default {
            isBroadcasting = false
        }
        if target != closest {
            isLiveListening = false
        }
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
        }
        return target
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
        if isLiveListening {
            isBroadcasting = false
            updateListenedStation(to: closestStations.first, withFocus: true)
        }
    }

}

extension NSSModel {

    public func closePreviouslyFocusedStation() {
        if let focused = focused, let station = allStations.open(differentFrom: focused) {
            withAnimation {
                station.open = false
            }
        }
    }
}

extension NSSModel {

    public func updateFocusedStation() {
        guard let focused = focused, let stations = stations else {
            self.focused = .default
            return
        }

        self.focused = stations.contains(focused)
            ? focused
            : .default
    }

}
