//
//  StationManagerDelegate.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 10/12/23.
//

import Foundation
import CoreLocation
import MusicKit
import OSLog

protocol NSSStationManagerDelegate: AnyObject {
    func manager(_ station: NSSStation, didInit `self`: NSSStation)
    func manager(_ station: NSSStation, willSetName newValue: String)
    func manager(_ station: NSSStation, didSetName oldValue: String)
    func manager(_ station: NSSStation, willSetMusicID newValue: String?)
    func manager(_ station: NSSStation, didSetMusicID oldValue: String?)
    func manager(_ station: NSSStation, willSetSong newValue: Song?)
    func manager(_ station: NSSStation, didSetSong oldValue: Song?)
    func manager(_ station: NSSStation, willSetLocation newValue: CLLocation?)
    func manager(_ station: NSSStation, didSetLocation oldValue: CLLocation?)
    func manager(_ station: NSSStation, willSetListeners newValue: Int)
    func manager(_ station: NSSStation, didSetListeners oldValue: Int)
    func manager(_ station: NSSStation, willSetOpen newValue: Bool)
    func manager(_ station: NSSStation, didSetOpen oldValue: Bool)
    func manager(_ station: NSSStation, didUpdateSong oldValue: Song?)
}

extension NSSStationManagerDelegate {
    func manager(_ station: NSSStation, didInit `self`: NSSStation) {}
    func manager(_ station: NSSStation, willSetName newValue: String) {}
    func manager(_ station: NSSStation, didSetName oldValue: String) {}
    func manager(_ station: NSSStation, willSetMusicID newValue: String?) {}
    func manager(_ station: NSSStation, didSetMusicID oldValue: String?) {}
    func manager(_ station: NSSStation, willSetSong newValue: Song?) {}
    func manager(_ station: NSSStation, didSetSong oldValue: Song?) {}
    func manager(_ station: NSSStation, willSetLocation newValue: CLLocation?) {}
    func manager(_ station: NSSStation, didSetLocation oldValue: CLLocation?) {}
    func manager(_ station: NSSStation, willSetListeners newValue: Int) {}
    func manager(_ station: NSSStation, didSetListeners oldValue: Int) {}
    func manager(_ station: NSSStation, willSetOpen newValue: Bool) {}
    func manager(_ station: NSSStation, didSetOpen oldValue: Bool) {}
    func manager(_ station: NSSStation, didUpdateSong oldValue: Song?) {}
}
