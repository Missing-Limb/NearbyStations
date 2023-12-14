//
//  StationAnnotation.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 12/12/23.
//

import SwiftUI
import MapKit

struct SMAnnotation: MapContent {

    private let station: NSSStation
    private let model: NSSModel

    init(_ station: NSSStation, _ model: NSSModel) {
        self.station = station
        self.model = model
    }

    var body: some MapContent {
        Group {
            if station == NSSStation.default {
                UserAnnotation { _ in
                    SMStation()
                        .environmentObject(station)
                        .environmentObject(model)
                }
            } else
            if let location = station.location {
                Annotation(coordinate: location.coordinate) {
                    SMStation()
                        .environmentObject(station)
                        .environmentObject(model)
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
