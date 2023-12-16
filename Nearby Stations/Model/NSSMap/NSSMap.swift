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
final class NSSMap: NSObject {

    public static let shared: NSSMap = .init(delegate: .debug)

    public static var authorized: Bool {
        NSSMap.shared.authorized
    }

    public static var location: CLLocation? {
        NSSMap.shared.location
    }

    public static var cameraPosition: MapCameraPosition {
        NSSMap.shared.cameraPosition
    }

    private var manager: CLLocationManager?

    public private(set) var authorized: Bool = false {
        didSet {
            NotificationCenter.default.post(name: .accessUpdate, object: nil)
        }
    }

    public var location: CLLocation?

    public var cameraPosition: MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)

    private init(delegate: NSSMapManagerDelegate?) {
        super.init()
        self.addObservers()
        self.manager = .init()
        self.manager!.delegate = self
        self.location = self.manager!.location
        self.requestAuthorization()
    }

    deinit {
        self.removeObservers()
    }

    internal func updateAuthorization() {
        self.authorized = [.authorizedWhenInUse, .authorizedAlways].contains(self.manager?.authorizationStatus)
    }

    private func requestAuthorization() {
        self.manager?.requestAlwaysAuthorization()
    }

}

extension NSSMap {

    @objc private func startUpdating() {
        self.manager?.startUpdatingLocation()
    }

    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(startUpdating), name: .accessGranted, object: nil)
    }

    private func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: .accessGranted, object: nil)
    }
}
