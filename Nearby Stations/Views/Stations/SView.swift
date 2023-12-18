//
//  StationView.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 07/12/23.
//

import SwiftUI
import MusicKit

struct SView: View {

    @Environment(NSSModel.self)
    private var model: NSSModel

    @Environment(NSSStyle.self)
    private var style: NSSStyle

    @State
    private var displayed: Bool = false

    let station: NSSStation

    private var displayFactor: Double {
        displayed ? 1.0 : 0.0
    }

    var body: some View {
        ZStack(alignment: .center) {
            VStack(alignment: .leading, spacing: style.spacing) {
                SDetails()
                    .isVisible(if: station.open)
                    .transition(.blur.combined(with: .opacity))
                SControls()
                    .disabled(station != .focused!)
                    .transition(.blur.combined(with: .opacity))
                SControlsDetails()
                    .isVisible(if: station.open)
                    .transition(.blur.combined(with: .opacity))
            }
            .padding(.all, style.spacing)
            .background {
                Rectangle()
                    .foregroundStyle(.thinMaterial)
            }
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .background {
                if !(model.isPlaying && station == .listened!) {
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(.regularMaterial, lineWidth: 1)
                        .foregroundStyle(.clear)
                }
            }
            .overlay {
                if model.isPlaying && station == .listened! {
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(.tint, lineWidth: 2)
                        .foregroundStyle(.clear)
                }
            }
        }
        .environment(station)
        .sensoryFeedback(.impact(flexibility: .soft, intensity: 0.5), trigger: station.open)
        .zIndex(station.open ? 2 : station == .focused! ? 1 : 0)
        .blur(radius: model.focused != nil && station != .focused! && model.focused!.open ? 4 : 0 )
        .offset(y: station.open ? 16 : 0 )
        .padding(.horizontal, station.open ? 0 : 8 )
        .containerRelativeFrame(
            .horizontal,
            count: 1,
            spacing: 16
        )
        .opacity(displayFactor)
        .onAppear(perform: toggleDisplayedState)
        .onDisappear(perform: toggleDisplayedState)
        .scrollTransition(axis: .horizontal, transition: {$0.brightness($1.isIdentity ? 0 : -0.15)})
        .gesture(
            DragGesture(
                minimumDistance: 20,
                coordinateSpace: .scrollView(axis: .vertical)
            )
            .onEnded { value in
                DispatchQueue.global(qos: .utility).async {
                    if (station.open && value.velocity.height > 0) || (!station.open && value.velocity.height < 0) {
                        withAnimation {
                            station.open.toggle()
                        }
                    }
                }
            }
        )
        .shadow(
            color: Color(white: 0, opacity: station.open ? 0.6 : 0.3),
            radius: station.open ? 32 : station == .focused!  ? 24 : 8,
            y: station.open ? 12 : station == .focused! ? 8 : 4
        )
        .id(station.id)
        .tag(station.id)
    }

    private func toggleDisplayedState() {
        DispatchQueue.global(qos: .utility).async {
            withAnimation {
                self.displayed.toggle()
            }
        }
    }
}
