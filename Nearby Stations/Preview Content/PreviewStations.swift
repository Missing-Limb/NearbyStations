//
//  PreviewStations.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 09/12/23.
//

import Foundation
import Collections
import CoreLocation

struct PreviewStations {

    static let defaultStations: Deque<NSSStation> = .init([
        NSSStation(
            name: "Station N°0",
            musicID: "574050602",
            location: CLLocationCoordinate2D(
                latitude: 40.85583,
                longitude: 14.26949
            ),
            delegate: .shared
        ),
        NSSStation(
            name: "Station N°1",
            musicID: "1440867107",
            location: CLLocationCoordinate2D(
                latitude: 40.85732,
                longitude: 14.27025
            ),
            delegate: .shared
        ),
        NSSStation(
            name: "Station N°2",
            musicID: "1440845362",
            location: CLLocationCoordinate2D(
                latitude: 40.85745,
                longitude: 14.26621
            ),
            delegate: .shared
        ),
        NSSStation(
            name: "Station N°3",
            musicID: "999397663",
            location: CLLocationCoordinate2D(
                latitude: 40.86292,
                longitude: 14.27325
            ),
            delegate: .shared
        ),
        NSSStation(
            name: "Station N°4",
            musicID: "1552269078",
            location: CLLocationCoordinate2D(
                latitude: 40.83663,
                longitude: 14.30660
            ),
            delegate: .shared
        ),
        NSSStation(
            name: "Welcome Desk",
            musicID: "273400021",
            location: CLLocationCoordinate2D(
                latitude: 40.836777,
                longitude: 14.305809
            ),
            delegate: .shared
        ),
        NSSStation(
            name: "Seminar",
            musicID: "1592329692",
            location: CLLocationCoordinate2D(
                latitude: 40.836909,
                longitude: 14.306493
            ),
            delegate: .shared
        )
    ])

}
