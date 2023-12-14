//
//  StationView.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 07/12/23.
//

import SwiftUI
import MusicKit

struct SView: View, Identifiable {

    @EnvironmentObject
    private var model: NSSModel

    let id: UUID?
    let station: NSSStation

    init(_ station: NSSStation) {
        self.station = station
        self.id = station.id
    }

    private var isFocused: Bool {
        self.model.focused == self.station
    }

    @State
    private var appearanceFactor: Double = 0

    var body: some View {
        ZStack(alignment: .center) {
            VStack(alignment: .leading, spacing: model.style.spacing) {
                SDetails()
                    .isVisible(if: self.station.open)
                    .transition(.blur.combined(with: .opacity))
                SControls()
                    .disabled(!self.isFocused)
                SControlsDetails()
                    .isVisible(if: self.station.open)
                    .transition(.blur.combined(with: .opacity))
            }
            .padding(.all, model.style.spacing)
            .background {
                Rectangle()
                    .foregroundStyle(.thinMaterial)
            }
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .background {
                if !(self.model.isPlaying && self.model.listened == self.station) {
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(.regularMaterial, lineWidth: 1)
                        .foregroundStyle(.clear)
                }
            }
            .overlay {
                if self.model.isPlaying && self.model.listened == self.station {
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(.accent, lineWidth: 2)
                        .foregroundStyle(.clear)
                }
            }
        }
        .environmentObject(station)
        .sensoryFeedback(.impact(flexibility: .soft, intensity: 0.5), trigger: self.station.open)
        .zIndex(self.station.open ? 2 : self.model.focused == station ? 1 : 0)
        .blur(radius: self.model.focused != nil && self.model.focused != station && self.model.focused!.open ? 4 : 0 )
        .offset(y: self.station.open ? 16 : 0 )
        .padding(.horizontal, self.station.open ? 0 : 8 )
        .containerRelativeFrame(
            .horizontal,
            count: 1,
            spacing: 16
        )
        .opacity(self.appearanceFactor)
        .onAppear {
            DispatchQueue.main.async {
                withAnimation {
                    self.appearanceFactor = 1
                }
            }
        }
        .scrollTransition(axis: .horizontal) { content, phase in
            content
                //                .saturation(phase.isIdentity ? 1 : 0 )
                .brightness(phase.isIdentity ? 0 : -0.15 )
        }
        .onDisappear {
            DispatchQueue.main.async {
                withAnimation {
                    self.appearanceFactor = 0
                }
            }
        }
        .gesture(
            DragGesture(
                minimumDistance: 20,
                coordinateSpace: .scrollView(axis: .vertical)
            )
            .onEnded { value in
                DispatchQueue.main.async {
                    withAnimation {
                        if self.station.open {
                            if value.velocity.height > 0 {
                                self.station.open.toggle()
                            }
                        } else
                        if value.velocity.height < 0 {
                            self.station.open.toggle()
                        }
                    }
                }
            }
        )
        .shadow(
            color: Color(white: 0, opacity: self.station.open ? 0.6 : 0.3),
            radius: self.station.open ? 32 : self.model.focused == self.station ? 24 : 8,
            y: self.station.open ? 12 : self.model.focused == self.station ? 8 : 4
        )
        .id(station.id)
    }
}
