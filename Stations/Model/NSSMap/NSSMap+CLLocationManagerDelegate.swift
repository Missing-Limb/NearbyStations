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
    }
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {}
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {}
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.location = manager.location
        NotificationCenter.default.post(name: .locationUpdate, object: self)
    }

}
