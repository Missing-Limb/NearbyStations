//
//  PreviewStations.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 09/12/23.
//

import Foundation
import Collections
import CoreLocation

// swiftlint:disable force_try

struct PreviewStations {

    static let defaultStations: Deque<NSSStation> = .init([
        NSSStation(
            name: "Station N°0",
            from: NSSSong(id: "574050602"),
            location: CLLocation(
                latitude: 40.85583,
                longitude: 14.26949
            )
        ),
        NSSStation(
            name: "Station N°1",
            from: NSSSong(id: "1440867107"),
            location: CLLocation(
                latitude: 40.85732,
                longitude: 14.27025
            )
        ),
        NSSStation(
            name: "Station N°2",
            from: NSSSong(id: "1440845362"),
            location: CLLocation(
                latitude: 40.85745,
                longitude: 14.26621
            )
        ),
        NSSStation(
            name: "Station N°3",
            from: NSSSong(id: "999397663"),
            location: CLLocation(
                latitude: 40.86292,
                longitude: 14.27325
            )
        ),
        NSSStation(
            name: "Station N°4",
            from: NSSSong(id: "1552269078"),
            location: CLLocation(
                latitude: 40.83663,
                longitude: 14.30660
            )
        ),
        NSSStation(
            name: "Welcome Desk",
            from: NSSSong(id: "273400021"),
            location: CLLocation(
                latitude: 40.836777,
                longitude: 14.305809
            )
        ),
        NSSStation(
            name: "Seminar",
            from: NSSSong(id: "1592329692"),
            location: CLLocation(
                latitude: 40.836909,
                longitude: 14.306493
            )
        )
    ])

}
