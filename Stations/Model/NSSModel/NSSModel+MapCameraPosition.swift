//
//  NSSModel+MapCameraPosition.swift
//  Nearby Stations
//
//  Created by Guillaume Coquard on 15/12/23.
//

import Foundation
import SwiftUI
import _MapKit_SwiftUI

// MARK: Moving Map Camera Position
extension NSSModel {

    private func updateCameraPosition(followsHeading: Bool = true) {
        withAnimation {
            NSSMap.shared.cameraPosition = .userLocation(followsHeading: followsHeading, fallback: .automatic)
        }
    }

    private func updateCameraPosition(
        to coordinate: CLLocationCoordinate2D,
        latitudinalMeters: CLLocationDistance = 200,
        longitudinalMeters: CLLocationDistance = 200
    ) {
        withAnimation {
            NSSMap.shared.cameraPosition = .region(.init(
                center: coordinate,
                latitudinalMeters: latitudinalMeters,
                longitudinalMeters: longitudinalMeters
            ))
        }
    }

    private func updateCameraPosition(
        to location: CLLocation,
        latitudinalMeters: CLLocationDistance = 200,
        longitudinalMeters: CLLocationDistance = 200
    ) {
        self.updateCameraPosition(
            to: location.coordinate,
            latitudinalMeters: latitudinalMeters,
            longitudinalMeters: longitudinalMeters
        )
    }

    private func updateCameraPosition(
        to station: NSSStation?,
        latitudinalMeters: CLLocationDistance = 200,
        longitudinalMeters: CLLocationDistance = 200
    ) {
        guard station != nil && station != NSSStation.default else {
            self.isFollowingUser = true
            return
        }
        if let location = station!.location {
            self.updateCameraPosition(
                to: location,
                latitudinalMeters: latitudinalMeters,
                longitudinalMeters: longitudinalMeters
            )
        }
    }

    public func moveCamera(to target: NSSFocus, _ station: NSSStation? = nil, followsHeading: Bool = true) {
        switch target {
        case .focused:
            self.updateCameraPosition(to: self.focused)
        case .listened:
            self.updateCameraPosition(to: self.listened)
        case .specific:
            self.updateCameraPosition(to: station)
        case .user:
            self.updateCameraPosition(followsHeading: followsHeading)
        }
    }
}
