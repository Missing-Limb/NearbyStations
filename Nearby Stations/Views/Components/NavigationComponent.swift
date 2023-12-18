//
//  NavigationComponent.swift
//  Nearby Stations
//
//  Created by Guillaume Coquard on 16/12/23.
//

import SwiftUI

struct NavigationComponent: View {

    @Environment(\.colorScheme)
    private var scheme: ColorScheme

    private var text: String
    private var systemImage: String

    init(_ text: String, systemImage: String) {
        self.text = text
        self.systemImage = systemImage
    }

    var body: some View {
        HStack(alignment: .center) {
            HStack(alignment: .center, spacing: 10) {
                HStack(alignment: .center) {
                    Image(systemName: systemImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.white)
                        .fontWeight(.semibold)
                        .padding(8)
                }
                .frame(width: 40, height: 40)
                .background(.tint)
                .clipShape(RoundedRectangle(cornerRadius: 8))

                Text(text)
                    .font(.title3)
                    .fontWeight(.medium)
                    .foregroundStyle(.foreground)
            }
            .accessibilityHidden(true)
            Spacer()
            Image(systemName: "chevron.forward")
                .font(.headline)
                .fontWeight(.medium)
                .foregroundStyle(.tint)
                .accessibilityHidden(true)
        }
        .padding([.vertical, .leading], 12)
        .padding(.trailing, 16)
        .background(.ultraThinMaterial.opacity(0.5))
        .background(.foreground.quinary.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .accessibilityLabel(text)
        .accessibilityAddTraits(.isLink)
    }
}
