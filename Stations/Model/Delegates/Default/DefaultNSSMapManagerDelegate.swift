//
//  DefaultNSSMapManagerDelegate.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 13/12/23.
//

extension NSSMapManagerDelegate where Self == DefaultNSSMapManagerDelegate {
    static var `default`: NSSMapManagerDelegate {
        DefaultNSSMapManagerDelegate()
    }
}

class DefaultNSSMapManagerDelegate: NSSMapManagerDelegate {}
