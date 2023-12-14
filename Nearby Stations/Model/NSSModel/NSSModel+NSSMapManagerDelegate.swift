//
//  NSSModel+NSSMapManagerDelegate.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 13/12/23.
//

import SwiftUI
import CoreLocation
import OSLog

protocol SharedNSSMapManagerDelegate: NSSMapManagerDelegate {}

extension NSSModel: NSSMapManagerDelegate {

    func manager(_ map: NSSMap, didInit `self`: NSSMap) {
        map.requestAuthorization()
        Logger.map.debug("didInitNSSMap")
        Logger.mapDelegate.debug("didInit")
    }

    func manager(_ map: NSSMap, didSetAuthorized oldValue: Bool) {
        if map.authorized {
            self.isLocationAccessible = true
        }
        Logger.mapDelegate.debug("didSetAuthorized - isLocationAccessible - set: \(self.isLocationAccessible)")
    }

    func manager(_ map: NSSMap, didSetLocation oldValue: CLLocation?) {
        DispatchQueue.main.async {
            if let location = map.location {
                withAnimation {
                    self.location = location
                }
            }
            Logger.mapDelegate.debug("didSetLocation - self.location - set: \(self.location)")
        }
    }

}
