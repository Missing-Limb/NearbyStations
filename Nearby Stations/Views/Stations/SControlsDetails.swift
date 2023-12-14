//
//  SControlsDetails.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 10/12/23.
//

import SwiftUI

struct SControlsDetails: View {

    @EnvironmentObject
    private var model: NSSModel

    @EnvironmentObject
    private var station: NSSStation

    var body: some View {
        VStack(alignment: .leading, spacing: model.style.spacing) {
            HStack(spacing: model.style.spacing) {
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

#Preview {
    SControlsDetails()
}
