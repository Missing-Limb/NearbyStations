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
    private var storage: NSSStorage         = .shared
    @State private var isPermissionsPresented: Bool = false
    private var shouldAskPermissions: Binding<Bool> {
        .init(
            get: { model.shouldAskPermissions },
            set: { newValue in isPermissionsPresented = newValue }
        )
    }

    var body: some Scene {
        WindowGroup {
            NSSMainView()
                .sheet(isPresented: shouldAskPermissions, content: {
                    PermissionsView(music, map)
                        .presentationBackground(.thickMaterial)
                        .presentationDragIndicator(.hidden)
                        .presentationCompactAdaptation(.automatic)
                        .presentationContentInteraction(.scrolls)
                        .presentationDetents([.medium])
                        .presentationBackgroundInteraction(.disabled)
                        .presentationCornerRadius(18)
                })
                .tint(Color(storage.selectedAccent))
                .environment(model)
                .environment(music)
                .environment(map)
                .environment(style)
        }
    }
}
