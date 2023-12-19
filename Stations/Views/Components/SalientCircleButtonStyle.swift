//
//  SalientCircleButton.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 10/12/23.
//

import SwiftUI

struct SalientCircleButtonStyle: ButtonStyle {

    @State
    private var contentSize: CGFloat = 32

    var highlightIf: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        Image(systemName: "plus")
            .foregroundStyle(.clear)
            .padding(12)
            .background {
                ZStack {
                    Group {
                        if highlightIf {
                            Circle()
                                .foregroundStyle(.tint)
                        } else {
                            Circle()
                        }
                    }
                    .foregroundStyle(.foreground.tertiary.opacity(0.5))
                    .foregroundStyle(.regularMaterial)
                    .background {
                        Circle()
                            .stroke(.ultraThinMaterial.opacity(0.5), lineWidth: 0.5, antialiased: true)
                            .foregroundStyle(.clear)
                            .blur(radius: 0.1)
                    }
                }
            }
            .padding(2)
            .overlay {
                configuration.label
                    .labelStyle(.iconOnly)
                    .foregroundStyle(highlightIf ? .white : .primary)
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            .frame(alignment: .center)
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}
