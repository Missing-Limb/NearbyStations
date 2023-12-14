//
//  NSSModelDelegate.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 10/12/23.
//

import Foundation
import Collections
import CoreLocation
import SwiftUI
import OSLog

protocol NSSModelManagerDelegate: AnyObject {
    func manager(_ model: NSSModel, didInit `self`: NSSModel)
    func manager(_ model: NSSModel, willSetDelegate newValue: NSSModelManagerDelegate?)
    func manager(_ model: NSSModel, didSetDelegate oldValue: NSSModelManagerDelegate?)
    func manager(_ model: NSSModel, willSetMusicAccessStatus newValue: Bool)
    func manager(_ model: NSSModel, didSetMusicAccessStatus oldValue: Bool)
    func manager(_ model: NSSModel, willSetLocationAccessStatus newValue: Bool)
    func manager(_ model: NSSModel, didSetLocationAccessStatus oldValue: Bool)
    func manager(_ model: NSSModel, willSetStationsInitializationStatus newValue: Bool)
    func manager(_ model: NSSModel, didSetStationsInitializationStatus oldValue: Bool)
    func manager(_ model: NSSModel, willSetScrollViewProxy newValue: ScrollViewProxy?)
    func manager(_ model: NSSModel, didSetScrollViewProxy oldValue: ScrollViewProxy?)
    func manager(_ model: NSSModel, willSetFocused newValue: NSSStation?)
    func manager(_ model: NSSModel, didSetFocused oldValue: NSSStation?)
    func manager(_ model: NSSModel, willSetListened newValue: NSSStation?)
    func manager(_ model: NSSModel, didSetListened oldValue: NSSStation?)
    func manager(_ model: NSSModel, willSetFollowingUserStatus newValue: Bool)
    func manager(_ model: NSSModel, didSetFollowingUserStatus oldValue: Bool)
    func manager(_ model: NSSModel, willSetBroadcastingStatus newValue: Bool)
    func manager(_ model: NSSModel, didSetBroadcastingStatus oldValue: Bool)
    func manager(_ model: NSSModel, willSetLiveListeningStatus newValue: Bool)
    func manager(_ model: NSSModel, didSetLiveListeningStatus oldValue: Bool)
    func manager(_ model: NSSModel, willSetPlayingStatus newValue: Bool)
    func manager(_ model: NSSModel, didSetPlayingStatus oldValue: Bool)
    func manager(_ model: NSSModel, willSetStations newValue: Set<NSSStation>)
    func manager(_ model: NSSModel, didSetStations oldValue: Set<NSSStation>)
    func manager(_ model: NSSModel, didComputeAllStations oldValue: OrderedSet<NSSStation>)
    func manager(_ model: NSSModel, willSetSortedStations newValue: Deque<NSSStation>)
    func manager(_ model: NSSModel, didSetSortedStations oldValue: Deque<NSSStation>)
    func manager(_ model: NSSModel, willSetLocation newValue: CLLocation?)
    func manager(_ model: NSSModel, didSetLocation oldValue: CLLocation?)
}

extension NSSModelManagerDelegate {
    func manager(_ model: NSSModel, didInit `self`: NSSModel) {}
    func manager(_ model: NSSModel, willSetDelegate newValue: NSSModelManagerDelegate?) {}
    func manager(_ model: NSSModel, didSetDelegate oldValue: NSSModelManagerDelegate?) {}
    func manager(_ model: NSSModel, willSetMusicAccessStatus newValue: Bool) {}
    func manager(_ model: NSSModel, didSetMusicAccessStatus oldValue: Bool) {}
    func manager(_ model: NSSModel, willSetLocationAccessStatus newValue: Bool) {}
    func manager(_ model: NSSModel, didSetLocationAccessStatus oldValue: Bool) {}
    func manager(_ model: NSSModel, willSetStationsInitializationStatus newValue: Bool) {}
    func manager(_ model: NSSModel, didSetStationsInitializationStatus oldValue: Bool) {}
    func manager(_ model: NSSModel, willSetScrollViewProxy newValue: ScrollViewProxy?) {}
    func manager(_ model: NSSModel, didSetScrollViewProxy oldValue: ScrollViewProxy?) {}
    func manager(_ model: NSSModel, willSetFocused newValue: NSSStation?) {}
    func manager(_ model: NSSModel, didSetFocused oldValue: NSSStation?) {}
    func manager(_ model: NSSModel, willSetListened newValue: NSSStation?) {}
    func manager(_ model: NSSModel, didSetListened oldValue: NSSStation?) {}
    func manager(_ model: NSSModel, willSetFollowingUserStatus newValue: Bool) {}
    func manager(_ model: NSSModel, didSetFollowingUserStatus oldValue: Bool) {}
    func manager(_ model: NSSModel, willSetBroadcastingStatus newValue: Bool) {}
    func manager(_ model: NSSModel, didSetBroadcastingStatus oldValue: Bool) {}
    func manager(_ model: NSSModel, willSetLiveListeningStatus newValue: Bool) {}
    func manager(_ model: NSSModel, didSetLiveListeningStatus oldValue: Bool) {}
    func manager(_ model: NSSModel, willSetPlayingStatus newValue: Bool) {}
    func manager(_ model: NSSModel, didSetPlayingStatus oldValue: Bool) {}
    func manager(_ model: NSSModel, willSetStations newValue: Set<NSSStation>) {}
    func manager(_ model: NSSModel, didSetStations oldValue: Set<NSSStation>) {}
    func manager(_ model: NSSModel, didComputeAllStations oldValue: OrderedSet<NSSStation>) {}
    func manager(_ model: NSSModel, willSetSortedStations newValue: Deque<NSSStation>) {}
    func manager(_ model: NSSModel, didSetSortedStations oldValue: Deque<NSSStation>) {}
    func manager(_ model: NSSModel, willSetLocation newValue: CLLocation?) {}
    func manager(_ model: NSSModel, didSetLocation oldValue: CLLocation?) {}
}
