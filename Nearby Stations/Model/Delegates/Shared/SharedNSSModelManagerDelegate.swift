//
//  SharedModelManagerDelegate.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 13/12/23.
//

import SwiftUI
import CoreLocation
import Collections
import OSLog

extension NSSModelManagerDelegate where Self == SharedNSSModelManagerDelegate {
    static var shared: NSSModelManagerDelegate {
        SharedNSSModelManagerDelegate()
    }
}

final class SharedNSSModelManagerDelegate: DebugNSSModelManagerDelegate {

    override init() {
        super.init()
    }

    override func manager(_ model: NSSModel, didInit `self`: NSSModel) {
        model.map = .init(delegate: self)
        model.music = .init(delegate: self)
        model.storage = .init(delegate: self)
        Logger.model.debug("didInitNSSModel")
        Logger.modelDelegate.debug("didInit")
    }

    override func manager(_ model: NSSModel, didSetMusicAccessStatus oldValue: Bool) {
        if model.isMusicAccessible && model.isLocationAccessible && !model.areStationsInitialized {
            model.areStationsInitialized = true
        }
        Logger.modelDelegate.debug("didSetMusicAccessStatus")
    }

    override func manager(_ model: NSSModel, didSetLocationAccessStatus oldValue: Bool) {
        if model.isMusicAccessible && model.isLocationAccessible && !model.areStationsInitialized {
            model.areStationsInitialized = true
        }
        Logger.modelDelegate.debug("didSetLocationAccessStatus")
    }

    override func manager(_ model: NSSModel, didSetStationsInitializationStatus oldValue: Bool) {
        if model.areStationsInitialized {
            model.map.startUpdatingLocation()
            model.updateStationsInformation()
            model.stations = .init(PreviewStations.defaultStations)
        }
    }

    override func manager(_ model: NSSModel, didSetFocused oldValue: NSSStation?) {
        DispatchQueue.main.async {
            if model.focused != nil, let station = model.allStations.open(differentFrom: model.focused!) {
                withAnimation {
                    station.open = false
                }
            }
            model.updateMapCameraPosition()
            Logger.modelDelegate.debug("didSetFocused")
        }
    }

    override func manager(_ model: NSSModel, didSetListened oldValue: NSSStation?) {
        if model.listened != NSSStation.default {
            model.isBroadcasting = false
        }
        Logger.modelDelegate.debug("didSetListened")
    }

    override func manager(_ model: NSSModel, didSetFollowingUserStatus oldValue: Bool) {
        DispatchQueue.main.async {
            if model.isFollowingUser {
                withAnimation {
                    model.map.cameraPosition = .userLocation(fallback: .automatic)
                }
            }
            Logger.modelDelegate.debug("didSetFollowingUserStatus")
        }
    }

    // TODO: Handle the fact that MY station can not contain a song
    override func manager(_ model: NSSModel, didSetBroadcastingStatus oldValue: Bool) {
        DispatchQueue.main.async {
            if model.isBroadcasting {
                withAnimation {
                    model.isLiveListening = false
                    if let focused = model.stations.first(where: { $0 == model.focused }),
                       focused.musicID != nil {
                        NSSStation.default.musicID = focused.musicID
                    }
                    model.focused = NSSStation.default
                    model.listened = NSSStation.default
                }
                model.updateMapCameraPosition()
                Logger.modelDelegate.debug("didSetBroadcastingStatus")
            }
        }
    }

    override func manager(_ model: NSSModel, didSetLiveListeningStatus oldValue: Bool) {
        if model.isLiveListening {
            model.isBroadcasting = false
            if let first = model.sortedStations.firstDifferent {
                model.focused = first
                model.listened = first
                model.isPlaying = true
            }
        }
        Logger.modelDelegate.debug("didSetLiveListeningStatus")
    }

    override func manager(_ model: NSSModel, didSetStations oldValue: Set<NSSStation>) {
        model.sortedStations = model.getAllClosestStations(to: model.location)
        Logger.modelDelegate.debug("didSetStations")
    }

    override func manager(_ model: NSSModel, didSetSortedStations oldValue: Deque<NSSStation>) {
        DispatchQueue.main.async {
            model.updateFocusedStation()
            model.updateListenedStation()
            //            model.updateScrollPosition()
            Logger.modelDelegate.debug("didSetSortedStations")
        }
    }

    override func manager(_ model: NSSModel, didSetLocation oldValue: CLLocation?) {
        DispatchQueue.main.async {
            if model.location != nil {
                NSSStation.default.location = model.location
                let sortedStations = model.getAllClosestStations(to: model.location)
                if model.sortedStations != sortedStations {
                    model.sortedStations = sortedStations
                }
            }
            Logger.modelDelegate.debug("didSetLocation")
        }
    }
}
