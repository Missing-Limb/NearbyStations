//
//  StationAnnotation.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 12/12/23.
//

import SwiftUI
import MapKit

struct SMAnnotation: MapContent {

    @Bindable
    private var station: NSSStation

    init(_ station: NSSStation) {
        self.station = station
    }

    var body: some MapContent {
        Group {
            if station == .default {
                UserAnnotation {
                    SMStation(station)
                }
            } else
            if let location = station.location {
                Annotation(coordinate: location.coordinate) {
                    SMStation(station)
                } label: {
                    Label("\(station.name)", systemImage: "antenna.radiowaves.left.and.right")
                }
            } else {
                EmptyMapContent()
            }
        }
        .annotationTitles(.hidden)
        .annotationSubtitles(.hidden)
        .mapOverlayLevel(level: .aboveLabels)
    }
}
