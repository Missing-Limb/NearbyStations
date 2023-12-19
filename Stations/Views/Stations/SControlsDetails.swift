//
//  SControlsDetails.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 10/12/23.
//

import SwiftUI

struct SControlsDetails: View {

    @Environment(NSSModel.self)
    private var model: NSSModel

    @Environment(NSSStation.self)
    private var station: NSSStation

    @Environment(NSSStyle.self)
    private var style: NSSStyle

    var body: some View {
        VStack(alignment: .leading, spacing: style.spacing) {
            HStack(spacing: style.spacing) {
                Button {
                    print("Open in Music")
                } label: {
                    HStack {
                        Spacer()
                        Label("Open in Music", systemImage: "arrow.up.forward.app")
                        Spacer()
                    }
                }

                Button {
                    print("More Actions")
                } label: {
                    HStack {
                        Label("More", systemImage: "ellipsis")
                            .labelStyle(.iconOnly)
                    }
                    .padding(7)
                }
            }
            .buttonStyle(SalientButtonStyle())
            .fontWeight(.semibold)
            .font(.headline)
        }
    }
}
