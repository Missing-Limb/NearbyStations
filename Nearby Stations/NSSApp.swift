//
//  StationSliderApp.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 07/12/23.
//

import SwiftUI
import MapKit

@main
struct NSSApp: App {

    @State
    private var model: NSSModel = .init(delegate: .shared)

    @State
    private var forceSubscriptionView: Bool = true

    var body: some Scene {
        WindowGroup {
            NSSMainView()
                .environmentObject(model)
                .musicSubscriptionOffer(isPresented: self.$model.music.needsToSubscribe)
        }
    }
}
