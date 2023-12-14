//
//  ControlsView.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 10/12/23.
//

import SwiftUI
import TipKit

struct SMControls: View {

    @EnvironmentObject
    private var model: NSSModel

    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 0) {

                ToggleButton($model.isBroadcasting) {
                    Label("Broadcasting", systemImage: "antenna.radiowaves.left.and.right")
                }
                .popoverTip(NSSTips.broadcastingModeTip.init(), arrowEdge: .trailing)

                ToggleButton($model.isLiveListening) {
                    Label("Live Listening", systemImage: "livephoto.play")
                }
                .popoverTip(NSSTips.liveListeningModeTip.init(), arrowEdge: .trailing)

            }
            .background(.thickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(alignment: .center) {
                ZStack {
                    Rectangle()
                        .foregroundStyle(.primary)
                        .opacity(0.2)
                        .frame(height: 1)
                        .scaledToFit()

                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.regularMaterial.opacity(0.5), lineWidth: 0.5, antialiased: true)
                        .foregroundStyle(.clear)
                        .blur(radius: 0.1)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .shadow(
                color: Color(white: 0, opacity: 0.3),
                radius: 24,
                y: 4
            )

            VStack {
                ToggleButton($model.isFollowingUser) {
                    Label("Focus", systemImage: "scope")
                }
                .background(.thickMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(alignment: .center) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(.regularMaterial.opacity(0.5), lineWidth: 0.5, antialiased: true)
                            .foregroundStyle(.clear)
                            .blur(radius: 0.1)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .shadow(
                    color: Color(white: 0, opacity: 0.3),
                    radius: 24,
                    y: 4
                )
            }
        }
    }
}
