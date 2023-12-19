//
//  StationMainControlsView.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 10/12/23.
//

import SwiftUI

struct SControls: View {

    @Environment(NSSModel.self)
    private var model: NSSModel

    @Environment(NSSStyle.self)
    private var style: NSSStyle

    @Environment(NSSStation.self)
    private var station: NSSStation

    var body: some View {
        HStack(spacing: style.spacing) {
            Button {
                DispatchQueue.global(qos: .userInteractive).async {
                    withAnimation {
                        self.station.open.toggle()
                    }
                }
            } label: {
                HStack(spacing: style.spacing - 2) {

                    SImage(station, size: 48.0)
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                    VStack(alignment: .leading, spacing: 4) {
                        Text(station.song?.title ?? "Loading...")
                            .lineLimit(1)
                            .font(.headline)
                            .fontWeight(.bold)
                        Text(station.song?.artist ?? "Loading...")
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
                            model.updatePlayingStatus()
                        }
                    }
                } label: {
                    Label(
                        model.isPlaying && model.listened == station ? "Pause" : "Play",
                        systemImage: model.isPlaying && model.listened == station
                            ? "pause.fill"
                            : "play.fill"
                    )
                }
                .buttonStyle(
                    SalientCircleButtonStyle(highlightIf: model.listened == station && model.isPlaying)
                )
            }
            .padding(.trailing, -4)
        }
    }
}
