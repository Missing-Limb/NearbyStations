//
//  NSSLocation.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 11/12/23.
//

import Foundation
import MapKit
import SwiftUI
import OSLog

@Observable
final class NSSMap: NSObject, ObservableObject {

    public static let shared: NSSMap = .init(delegate: .default)

    public var delegate: NSSMapManagerDelegate? {
        willSet {
            self.delegate?.manager(self, willSetDelegate: newValue)
        }
        didSet {
            self.delegate?.manager(self, didSetDelegate: oldValue)
        }
    }

    public private(set) var authorized: Bool = false {
        willSet {
            self.delegate?.manager(self, willSetAuthorized: newValue)
        }
        didSet {
            self.delegate?.manager(self, didSetAuthorized: oldValue)
        }
    }

    public private(set) var location: CLLocation? {
        willSet {
            self.delegate?.manager(self, willSetLocation: newValue)
        }
        didSet {
            self.delegate?.manager(self, didSetLocation: oldValue)
        }
    }

    public var manager: CLLocationManager? {
        willSet {
            self.delegate?.manager(self, willSetCLLManager: newValue)
        }
        didSet {
            self.delegate?.manager(self, didSetCLLManager: oldValue)
        }
    }

    public var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic) {
        willSet {
            self.delegate?.manager(self, willSetCameraPosition: newValue)
        }
        didSet {
            self.delegate?.manager(self, didSetCameraPosition: oldValue)
        }
    }

    init(delegate: NSSMapManagerDelegate? = nil) {
        Logger.map.debug("willInitNSSMap")
        self.delegate = delegate
        self.manager = .init()
        super.init()
        self.manager?.delegate = self
        self.delegate?.manager(self, didInit: self)
    }

    func requestAuthorization() {
        Logger.map.debug(".requestAlwaysAuthorization")
        self.manager?.requestAlwaysAuthorization()
    }

    func updateAuthorization() {
        Logger.map.debug(".updateAuthorization")
        self.authorized = [.authorizedWhenInUse, .authorizedAlways].contains(self.manager?.authorizationStatus)
        Logger.map.debug(".updateAuthorization - authorized - set: \(self.authorized)")
    }

    func startUpdatingLocation() {
        Logger.map.debug(".startUpdatingLocation")
        self.manager?.startUpdatingLocation()
    }

    func updateLocation() {
        Logger.map.debug(".updateLocation")
        if let manager = self.manager, let location = manager.location {
            self.location = location
        }
    }
}
