//
//  NSSMode+CLLocationManager.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 13/12/23.
//

import SwiftUI
import CoreLocation
import OSLog

extension NSSMap: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.updateAuthorization()
        Logger.map.debug("locationManagerDidChangeAuthorization(_)")
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.updateLocation()
        Logger.map.debug("locationManager(_,didUpdateLocations)")
    }
}
