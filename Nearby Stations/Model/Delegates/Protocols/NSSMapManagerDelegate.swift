//
//  NSSMapManagerDelegate.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 12/12/23.
//

import Foundation
import CoreLocation
import _MapKit_SwiftUI
import OSLog

protocol NSSMapManagerDelegate: AnyObject {
    func manager(_ map: NSSMap, willInit `self`: NSSMap)
    func manager(_ map: NSSMap, didInit `self`: NSSMap)
    func manager(_ map: NSSMap, willSetDelegate newValue: NSSMapManagerDelegate?)
    func manager(_ map: NSSMap, didSetDelegate oldValue: NSSMapManagerDelegate?)
    func manager(_ map: NSSMap, willSetAuthorized newValue: Bool)
    func manager(_ map: NSSMap, didSetAuthorized oldValue: Bool)
    func manager(_ map: NSSMap, willSetCLLManager newValue: CLLocationManager?)
    func manager(_ map: NSSMap, didSetCLLManager oldValue: CLLocationManager?)
    func manager(_ map: NSSMap, willSetCameraPosition newValue: MapCameraPosition)
    func manager(_ map: NSSMap, didSetCameraPosition oldValue: MapCameraPosition)
}

extension NSSMapManagerDelegate {
    func manager(_ map: NSSMap, willInit `self`: NSSMap) {}
    func manager(_ map: NSSMap, didInit `self`: NSSMap) {}
    func manager(_ map: NSSMap, willSetDelegate newValue: NSSMapManagerDelegate?) {}
    func manager(_ map: NSSMap, didSetDelegate oldValue: NSSMapManagerDelegate?) {}
    func manager(_ map: NSSMap, willSetAuthorized newValue: Bool) {}
    func manager(_ map: NSSMap, didSetAuthorized oldValue: Bool) {}
    func manager(_ map: NSSMap, willSetCLLManager newValue: CLLocationManager?) {}
    func manager(_ map: NSSMap, didSetCLLManager oldValue: CLLocationManager?) {}
    func manager(_ map: NSSMap, willSetCameraPosition newValue: MapCameraPosition) {}
    func manager(_ map: NSSMap, didSetCameraPosition oldValue: MapCameraPosition) {}
}
