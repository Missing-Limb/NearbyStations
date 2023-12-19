//
//  Permissions&StatusView.swift
//  Nearby Stations
//
//  Created by Guillaume Coquard on 16/12/23.
//

import SwiftUI
import MusicKit
import OSLog

struct PermissionsView: View {

    @Bindable
    private var music: NSSMusic

    @Bindable
    private var map: NSSMap

    @State
    private var isSubscriptionViewPresented: Bool = false

    init(_ music: NSSMusic, _ map: NSSMap) {
        self.music = music
        self.map = map
    }

    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 16) {
                    PermissionButton("Music Access", status: $music.authorized) {
                        Task {
                            await music.requestAuthorization($isSubscriptionViewPresented)
                        }
                    }
                    PermissionButton("Location Access", status: $map.authorized) {
                        map.requestAuthorization()
                    }
                }
            }
            .scrollClipDisabled()
            .safeAreaPadding()
            .background(.clear)
            .navigationTitle("Permissions")
            .navigationBarTitleDisplayMode(.inline)
        }
        .musicSubscriptionOffer(isPresented: $isSubscriptionViewPresented) { error in
            if let error = error {
                Logger.music.error("\(error.localizedDescription)")
            }
            Task {
                await music.requestAuthorization()
            }
        }
    }
}
