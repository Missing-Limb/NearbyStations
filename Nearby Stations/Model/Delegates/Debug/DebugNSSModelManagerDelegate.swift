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

protocol DebugNSSModelManagerDelegateProtocol: NSSModelManagerDelegate {}

extension DebugNSSModelManagerDelegateProtocol {
    func manager(_ model: NSSModel, willInit `self`: NSSModel) {
        Logger.modelDelegate.debug("willInit - \(String(describing: `self`))")
    }
    func manager(_ model: NSSModel, didInit `self`: NSSModel) {
        Logger.modelDelegate.debug("didInit - \(String(describing: `self`))")
    }
    func manager(_ model: NSSModel, willSetDelegate newValue: NSSModelManagerDelegate?) {
        Logger.modelDelegate.debug("willSetDelegate")
    }
    func manager(_ model: NSSModel, didSetDelegate oldValue: NSSModelManagerDelegate?) {
        Logger.modelDelegate.debug("didSetDelegate")
    }
    func manager(_ model: NSSModel, willSetMusicAccess newValue: Bool) {
        Logger.modelDelegate.debug("willSetMusicAccess")
    }
    func manager(_ model: NSSModel, didSetMusicAccess oldValue: Bool) {
        Logger.modelDelegate.debug("didSetMusicAccess")
    }
    func manager(_ model: NSSModel, willSetLocationAccess newValue: Bool) {
        Logger.modelDelegate.debug("willSetLocationAccess")
    }
    func manager(_ model: NSSModel, didSetLocationAccess oldValue: Bool) {
        Logger.modelDelegate.debug("didSetLocationAccess")
    }
    func manager(_ model: NSSModel, willSetStationsInitializability newValue: Bool) {
        Logger.modelDelegate.debug("willSetStationsInitializability")
    }
    func manager(_ model: NSSModel, didSetStationsInitializability oldValue: Bool) {
        Logger.modelDelegate.debug("didSetStationsInitializability")
    }
    func manager(_ model: NSSModel, willSetStationsInitialization newValue: Bool) {
        Logger.modelDelegate.debug("willSetStationsInitialization")
    }
    func manager(_ model: NSSModel, didSetStationsInitialization oldValue: Bool) {
        Logger.modelDelegate.debug("didSetStationsInitialization")
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
    func manager(_ model: NSSModel, willSetStations newValue: Set<NSSStation>?) {
        Logger.modelDelegate.debug("willSetStations")
    }
    func manager(_ model: NSSModel, didSetStations oldValue: Set<NSSStation>?) {
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

class DebugNSSModelManagerDelegate: DebugNSSModelManagerDelegateProtocol {}
