//
//  ServicesView.swift
//  Nearby Stations
//
//  Created by Guillaume Coquard on 16/12/23.
//

import SwiftUI
import MusicKit

struct ServicesView: View {

    @State
    private var isPresented: Bool = false

    @State
    private var spotify: Bool = false

    @Bindable
    internal var music: NSSMusic

    var body: some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading, spacing: 16) {
                PermissionButton("Apple Music", status: $music.authorized) {requestAppleMusic()}
                PermissionButton("Spotify", status: $spotify) {requestSpotify()}
                    .tint(NSSColors.from(.spotify))
            }
            .safeAreaPadding()
        }
        .musicSubscriptionOffer(isPresented: $isPresented) { _ in requestAppleMusic() }
        .navigationTitle("Services")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func requestAppleMusic() {
        Task {
            await music.requestAuthorization($isPresented)
        }
    }

    private func requestSpotify(_ error: (any Error)? = nil) {

    }
}
