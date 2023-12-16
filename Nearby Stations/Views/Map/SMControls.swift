//
//  ControlsView.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 10/12/23.
//

import SwiftUI
import TipKit

struct SMControls: View {

    @State
    private var model: NSSModel = .shared

    var body: some View {
        VStack(spacing: 32) {
            VStack(spacing: 0) {

                ToggleButton($model.isBroadcasting, animated: true) {
                    Label("Broadcasting", systemImage: "antenna.radiowaves.left.and.right")
                } completion: {
                    print("Tapped")
                }
                .popoverTip(NSSTips.broadcastingModeTip.init(), arrowEdge: .trailing)

                ToggleButton($model.isLiveListening, animated: true) {
                    Label("Live Listening", systemImage: "livephoto.play")
                } completion: {
                    print("Tapped")
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
                    Label("Focus", systemImage: model.isFollowingUser ? "location.north.fill" : "location.north")
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
