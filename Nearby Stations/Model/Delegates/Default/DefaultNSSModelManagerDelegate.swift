//
//  DefaultNSSModelManagerDelegate.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 13/12/23.
//

import ObjectiveC

extension NSSModelManagerDelegate where Self == DefaultNSSModelManagerDelegate {
    static var `default`: NSSModelManagerDelegate {
        DefaultNSSModelManagerDelegate()
    }
}

class DefaultNSSModelManagerDelegate: NSSModelManagerDelegate {}
