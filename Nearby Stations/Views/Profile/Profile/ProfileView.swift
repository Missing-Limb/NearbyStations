//
//  ProfileView.swift
//  Nearby Stations
//
//  Created by Guillaume Coquard on 16/12/23.
//

import SwiftUI

struct ProfileView: View {

    @Environment(NSSMusic.self)
    private var music: NSSMusic

    @Environment(NSSMap.self)
    private var map: NSSMap

    var body: some View {
        NavigationStack {
            ScrollView {
                NavigationLink {
                    PermissionsView(music, map)
                } label: {
                    NavigationComponent("Permissions", systemImage: "checkmark.seal")
                }
                NavigationLink {
                    ServicesView(music: music)
                } label: {
                    NavigationComponent("Services", systemImage: "app")
                }
            }
            .scrollClipDisabled()
            .safeAreaPadding()
            .navigationTitle(NSSStorage.shared.myStationName)
            .navigationBarTitleDisplayMode(.large)
        }
        .presentationBackground(.thickMaterial)
        .presentationDragIndicator(.visible)
        .presentationCompactAdaptation(.automatic)
        .presentationContentInteraction(.scrolls)
        .presentationDetents([.medium])
        .presentationBackgroundInteraction(.disabled)
        .presentationCornerRadius(18)
    }
}
