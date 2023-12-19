//
//  DefaultNSSStationManagerDelegate.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 13/12/23.
//

import ObjectiveC

extension NSSStationManagerDelegate where Self == DefaultNSSStationManagerDelegate {
    static var `default`: NSSStationManagerDelegate {
        DefaultNSSStationManagerDelegate()
    }
}

class DefaultNSSStationManagerDelegate: NSSStationManagerDelegate {}
