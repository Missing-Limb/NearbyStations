//
//  StationMainControlsView.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 10/12/23.
//

import SwiftUI

struct SControls: View {

    @EnvironmentObject
    private var model: NSSModel

    @EnvironmentObject
    private var station: NSSStation

    var body: some View {
        HStack(spacing: model.style.spacing) {
            Button {
                DispatchQueue.main.async {
                    withAnimation {
                        self.station.open.toggle()
                    }
                }
            } label: {
                HStack(spacing: model.style.spacing - 2) {

                    SImage(station, size: 48.0)
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                    VStack(alignment: .leading, spacing: 4) {
                        Text(self.station.song?.title ?? "Loading...")
                            .lineLimit(1)
                            .font(.headline)
                            .fontWeight(.bold)
                        Text(self.station.song?.artistName ?? "Loading...")
                            .lineLimit(1)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                }
            }
            .buttonStyle(.plain)

            Spacer(minLength: 0)

            HStack(spacing: 0) {
                Button {
                    print("Add to the library")
                } label: {
                    Label("Add to Library", systemImage: "plus")
                }
                .buttonStyle(SalientCircleButtonStyle())

                Button {
                    DispatchQueue.main.async {
                        withAnimation {
                            if self.model.isPlaying {
                                if self.model.listened == self.model.focused {
                                    self.model.isPlaying = false
                                }
                            } else {
                                self.model.isPlaying = true
                            }
                            if self.model.isPlaying {
                                self.model.listened = self.model.focused
                                if model.focused != NSSStation.default {
                                    model.isBroadcasting = false
                                }
                                if let first = self.model.sortedStations.firstDifferent,
                                   self.model.focused != first {
                                    model.isLiveListening = false
                                }
                            }
                        }
                    }
                } label: {
                    Label(
                        self.model.isPlaying && self.model.listened == self.station ? "Pause" : "Play",
                        systemImage: self.model.isPlaying && self.model.listened == self.station
                            ? "pause.fill"
                            : "play.fill"
                    )
                }
                .buttonStyle(
                    SalientCircleButtonStyle(highlightIf: self.model.listened == self.station && self.model.isPlaying)
                )
            }
            .padding(.trailing, -4)
        }
    }
}
