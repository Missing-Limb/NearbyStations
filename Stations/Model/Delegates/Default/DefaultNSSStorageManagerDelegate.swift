//
//  DefaultNSSStorageManagerDelegate.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 13/12/23.
//

extension NSSStorageManagerDelegate where Self == DefaultNSSStorageManagerDelegate {
    static var `default`: NSSStorageManagerDelegate {
        DefaultNSSStorageManagerDelegate()
    }
}

class DefaultNSSStorageManagerDelegate: NSSStorageManagerDelegate {}
