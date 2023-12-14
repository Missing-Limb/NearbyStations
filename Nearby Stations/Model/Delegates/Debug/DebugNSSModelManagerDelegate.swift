//
//  DebugNSSModelManagerDelegate.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 13/12/23.
//

import SwiftUI
import CoreLocation
import Collections
import OSLog

extension NSSModelManagerDelegate where Self == DebugNSSModelManagerDelegate {
    static var debug: NSSModelManagerDelegate {
        DebugNSSModelManagerDelegate()
    }
}

class DebugNSSModelManagerDelegate: NSSModelManagerDelegate {
    func manager(_ model: NSSModel, didInit `self`: NSSModel) {
        Logger.model.debug("didInitNSSModel")
        Logger.modelDelegate.debug("didInit")
    }
    func manager(_ model: NSSModel, willSetDelegate newValue: NSSModelManagerDelegate?) {
        Logger.modelDelegate.debug("willSetDelegate")
    }
    func manager(_ model: NSSModel, didSetDelegate oldValue: NSSModelManagerDelegate?) {
        Logger.modelDelegate.debug("didSetDelegate")
    }
    func manager(_ model: NSSModel, willSetMusicAccessStatus newValue: Bool) {
        Logger.modelDelegate.debug("willSetMusicAccessStatus")
    }
    func manager(_ model: NSSModel, didSetMusicAccessStatus oldValue: Bool) {
        Logger.modelDelegate.debug("didSetMusicAccessStatus")
    }
    func manager(_ model: NSSModel, willSetLocationAccessStatus newValue: Bool) {
        Logger.modelDelegate.debug("willSetLocationAccessStatus")
    }
    func manager(_ model: NSSModel, didSetLocationAccessStatus oldValue: Bool) {
        Logger.modelDelegate.debug("didSetLocationAccessStatus")
    }
    func manager(_ model: NSSModel, willSetStationsInitializationStatus newValue: Bool) {
        Logger.modelDelegate.debug("willSetStationsInitializationStatus")
    }
    func manager(_ model: NSSModel, didSetStationsInitializationStatus oldValue: Bool) {
        Logger.modelDelegate.debug("didSetStationsInitializationStatus")
    }
    func manager(_ model: NSSModel, willSetScrollViewProxy newValue: ScrollViewProxy?) {
        Logger.modelDelegate.debug("willSetScrollViewProxy")
    }
    func manager(_ model: NSSModel, didSetScrollViewProxy oldValue: ScrollViewProxy?) {
        Logger.modelDelegate.debug("didSetScrollViewProxy")
    }
    func manager(_ model: NSSModel, willSetFocused newValue: NSSStation?) {
        Logger.modelDelegate.debug("willSetFocused")
    }
    func manager(_ model: NSSModel, didSetFocused oldValue: NSSStation?) {
        Logger.modelDelegate.debug("didSetFocused")
    }
    func manager(_ model: NSSModel, willSetListened newValue: NSSStation?) {
        Logger.modelDelegate.debug("willSetListened")
    }
    func manager(_ model: NSSModel, didSetListened oldValue: NSSStation?) {
        Logger.modelDelegate.debug("didSetListened")
    }
    func manager(_ model: NSSModel, willSetFollowingUserStatus newValue: Bool) {
        Logger.modelDelegate.debug("willSetFollowingUserStatus")
    }
    func manager(_ model: NSSModel, didSetFollowingUserStatus oldValue: Bool) {
        Logger.modelDelegate.debug("didSetFollowingUserStatus")
    }
    func manager(_ model: NSSModel, willSetBroadcastingStatus newValue: Bool) {
        Logger.modelDelegate.debug("willSetBroadcastingStatus")
    }
    func manager(_ model: NSSModel, didSetBroadcastingStatus oldValue: Bool) {
        Logger.modelDelegate.debug("didSetBroadcastingStatus")
    }
    func manager(_ model: NSSModel, willSetLiveListeningStatus newValue: Bool) {
        Logger.modelDelegate.debug("willSetLiveListeningStatus")
    }
    func manager(_ model: NSSModel, didSetLiveListeningStatus oldValue: Bool) {
        Logger.modelDelegate.debug("didSetLiveListeningStatus")
    }
    func manager(_ model: NSSModel, willSetPlayingStatus newValue: Bool) {
        Logger.modelDelegate.debug("willSetPlayingStatus")
    }
    func manager(_ model: NSSModel, didSetPlayingStatus oldValue: Bool) {
        Logger.modelDelegate.debug("didSetPlayingStatus")
    }
    func manager(_ model: NSSModel, willSetStations newValue: Set<NSSStation>) {
        Logger.modelDelegate.debug("willSetStations")
    }
    func manager(_ model: NSSModel, didSetStations oldValue: Set<NSSStation>) {
        Logger.modelDelegate.debug("didSetStations")
    }
    func manager(_ model: NSSModel, didComputeAllStations oldValue: OrderedSet<NSSStation>) {
        Logger.modelDelegate.debug("didComputeAllStations")
    }
    func manager(_ model: NSSModel, willSetSortedStations newValue: Deque<NSSStation>) {
        Logger.modelDelegate.debug("willSetSortedStations")
    }
    func manager(_ model: NSSModel, didSetSortedStations oldValue: Deque<NSSStation>) {
        Logger.modelDelegate.debug("didSetSortedStations")
    }
    func manager(_ model: NSSModel, willSetLocation newValue: CLLocation?) {
        Logger.modelDelegate.debug("willSetLocation")
    }
    func manager(_ model: NSSModel, didSetLocation oldValue: CLLocation?) {
        Logger.modelDelegate.debug("didSetLocation")
    }
}
