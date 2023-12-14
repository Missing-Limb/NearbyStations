//
//  SharedMapManagerDelegate.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 13/12/23.
//

import Foundation
import CoreLocation
import _MapKit_SwiftUI
import OSLog

extension NSSMapManagerDelegate where Self == DebugNSSMapManagerDelegate {
    static var debug: NSSMapManagerDelegate {
        DebugNSSMapManagerDelegate()
    }
}

class DebugNSSMapManagerDelegate: NSSMapManagerDelegate {
    func manager(_ map: NSSMap, didInit `self`: NSSMap) {
        Logger.map.debug("didInitNSSMap")
        Logger.mapDelegate.debug("didInit")
    }
    func manager(_ map: NSSMap, willSetDelegate newValue: NSSMapManagerDelegate?) {
        Logger.mapDelegate.debug("willSetDelegate")
    }
    func manager(_ map: NSSMap, didSetDelegate oldValue: NSSMapManagerDelegate?) {
        Logger.mapDelegate.debug("didSetDelegate")
    }
    func manager(_ map: NSSMap, willSetAuthorized newValue: Bool) {
        Logger.mapDelegate.debug("willSetAuthorization")
    }
    func manager(_ map: NSSMap, didSetAuthorized oldValue: Bool) {
        Logger.mapDelegate.debug("didSetAuthorization")
    }
    func manager(_ map: NSSMap, willSetLocation newValue: CLLocation?) {
        Logger.mapDelegate.debug("willSetLocation")
    }
    func manager(_ map: NSSMap, didSetLocation oldValue: CLLocation?) {
        Logger.mapDelegate.debug("didSetLocation")
    }
    func manager(_ map: NSSMap, willSetCLLManager newValue: CLLocationManager?) {
        Logger.mapDelegate.debug("willSetCLLManager")
    }
    func manager(_ map: NSSMap, didSetCLLManager oldValue: CLLocationManager?) {
        Logger.mapDelegate.debug("didSetCLLManager")
    }
    func manager(_ map: NSSMap, willSetCameraPosition newValue: MapCameraPosition) {
        Logger.mapDelegate.debug("willSetCameraPosition")
    }
    func manager(_ map: NSSMap, didSetCameraPosition oldValue: MapCameraPosition) {
        Logger.mapDelegate.debug("didSetCameraPosition")
    }
}
