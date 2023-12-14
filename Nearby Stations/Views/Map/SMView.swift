//
//  NSSMapView.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 10/12/23.
//

import SwiftUI
import MapKit

struct SMView: View {

    @EnvironmentObject
    private var model: NSSModel

    var body: some View {
        Map(position: self.$model.map.cameraPosition, interactionModes: [.pan, .zoom, .rotate]) {
            ForEach(self.model.allStations) { station in
                SMAnnotation(station, model)
            }
        }
        .mapFeatureSelectionDisabled { _ in false }
        .mapFeatureSelectionContent { _ in }
        .mapStyle(.standard(pointsOfInterest: .excludingAll))
        .onChange(of: self.model.map.cameraPosition.followsUserLocation) {
            self.model.isFollowingUser = self.model.map.cameraPosition.followsUserLocation
        }
    }
}
