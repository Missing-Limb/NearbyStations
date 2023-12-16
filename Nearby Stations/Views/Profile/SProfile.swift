//
//  SProfile.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 11/12/23.
//

import SwiftUI

struct SProfile: View {

    @Environment(NSSModel.self)
    private var model: NSSModel

    @State
    private var isPresented: Bool = false

    var body: some View {

        ToggleButton($isPresented) {
            Label("Profile", systemImage: "person.crop.circle.fill")
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
        .sheet(isPresented: $isPresented) {
            VStack {
                HStack {
                    Text(NSSStorage.shared.myStationName)
                        .font(.title)
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                }
            }
            .background(.clear)
            .presentationDetents([.medium])
            .presentationBackground {
                Rectangle()
                    .foregroundStyle(.regularMaterial)
            }
            .presentationDragIndicator(.visible)
            .presentationBackgroundInteraction(.disabled)
        }

    }
}

#Preview {
    SProfile()
}
