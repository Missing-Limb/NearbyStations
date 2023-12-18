//
//  NSSStationDebugManagerDelegate.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 13/12/23.
//

import Foundation
import CoreLocation
import MusicKit
import OSLog

extension NSSStationManagerDelegate where Self == DebugNSSStationManagerDelegate {
    static var debug: NSSStationManagerDelegate {
        DebugNSSStationManagerDelegate()
    }
}

protocol DebugNSSStationManagerDelegateProtocol: NSSStationManagerDelegate {}

extension DebugNSSStationManagerDelegateProtocol {
    func manager(_ station: NSSStation, willInit `self`: NSSStation) {
        Logger.stationDelegate.debug("willInit - self: \(String(describing: `self`))")
    }
    func manager(_ station: NSSStation, didInit `self`: NSSStation) {
        Logger.stationDelegate.debug("didInit - self: \(String(describing: `self`))")
    }
    func manager(_ station: NSSStation, willSetName newValue: String) {
        Logger.stationDelegate.debug("willSetName")
    }
    func manager(_ station: NSSStation, didSetName oldValue: String) {
        Logger.stationDelegate.debug("didSetName")
    }
    func manager(_ station: NSSStation, willSetMusicID newValue: String?) {
        Logger.stationDelegate.debug("willSetMusicID")
    }
    func manager(_ station: NSSStation, didSetMusicID oldValue: String?) {
        Logger.stationDelegate.debug("didSetMusicID")
    }
    func manager(_ station: NSSStation, willSetSong newValue: Song?) {
        Logger.stationDelegate.debug("willSetSong")
    }
    func manager(_ station: NSSStation, didSetSong oldValue: Song?) {
        Logger.stationDelegate.debug("didSetSong")
    }
    func manager(_ station: NSSStation, willSetLocation newValue: CLLocation?) {
        Logger.stationDelegate.debug("willSetLocation")
    }
    func manager(_ station: NSSStation, didSetLocation oldValue: CLLocation?) {
        Logger.stationDelegate.debug("didSetLocation")
    }
    func manager(_ station: NSSStation, willSetListeners newValue: Int) {
        Logger.stationDelegate.debug("willSetListeners")
    }
    func manager(_ station: NSSStation, didSetListeners oldValue: Int) {
        Logger.stationDelegate.debug("didSetListeners")
    }
    func manager(_ station: NSSStation, willSetOpen newValue: Bool) {
        Logger.stationDelegate.debug("willSetOpen")
    }
    func manager(_ station: NSSStation, didSetOpen oldValue: Bool) {
        Logger.stationDelegate.debug("didSetOpen")
    }
    func manager(_ station: NSSStation, willSetArtwork newValue: Data?) {
        Logger.stationDelegate.debug("willSetArtwork")
    }
    func manager(_ station: NSSStation, didSetArtwork oldValue: Data?) {
        Logger.stationDelegate.debug("didSetArtwork")
    }
    func manager(_ station: NSSStation, didUpdateSong oldValue: Song?) {
        Logger.stationDelegate.debug("didUpdateSong")
    }
}

class DebugNSSStationManagerDelegate: DebugNSSStationManagerDelegateProtocol {}
