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

    @State private var model: NSSModel      = .shared
    @State private var music: NSSMusic      = .shared
    @State private var map: NSSMap          = .shared
    @State private var style: NSSStyle      = .shared
    private var storage: NSSStorage  = .shared

    var body: some Scene {
        WindowGroup {
            NSSMainView()
                .tint(Color(storage.selectedAccent))
                .environment(model)
                .environment(music)
                .environment(map)
                .environment(style)
        }
    }
}
