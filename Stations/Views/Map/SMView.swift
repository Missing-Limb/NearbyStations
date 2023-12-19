//
//  NSSMapView.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 10/12/23.
//

import SwiftUI
import _MapKit_SwiftUI
import OSLog

struct SMView: View {

    @State private var model: NSSModel    = .shared
    @State private var map: NSSMap      = .shared

    var body: some View {
        Map(position: $map.cameraPosition, interactionModes: [.pan, .zoom, .rotate] ) {
            ForEach(model.allClosestStations) { station in
                SMAnnotation(station)
                    .tag(station.id)
            }
        }
        .mapControls {}
        .mapStyle(.standard(pointsOfInterest: .excludingAll))
        .onChange(of: map.cameraPosition.followsUserLocation) {
            NotificationCenter.default.post(name: .cameraUpdate, object: map.cameraPosition)
        }
    }
}
