//
//  SDetails.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 11/12/23.
//

import SwiftUI

struct SDetails: View {

    @Environment(NSSModel.self)
    private var model: NSSModel

    @Environment(NSSStyle.self)
    private var style: NSSStyle

    @Environment(NSSStation.self)
    private var station: NSSStation

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: style.spacing) {
                Text(station.name)
                Spacer()
                HStack(spacing: 0) {
                    if station.listeners == 0 {
                        Image(systemName: "shareplay.slash")
                    } else {
                        Text("\(station.listeners)")
                        Image(systemName: "shareplay")
                    }
                }
                .accessibilityLabel("\(station.listeners) Listeners")
            }
            .kerning(1)
            .textCase(.uppercase)
            .font(.subheadline)
            .fontDesign(.rounded)
            .fontWeight(.bold)
            .foregroundStyle(.foreground.secondary)
        }
    }
}

#Preview {
    SDetails()
}
