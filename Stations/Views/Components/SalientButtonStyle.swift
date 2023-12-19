//
//  SalientButton.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 09/12/23.
//

import SwiftUI
import OSLog

struct SalientButtonStyle: ButtonStyle {

    @State
    private var radius: CGFloat = 8

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.primary)
            .padding(.vertical, 7)
            .padding(.horizontal, 10)
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: radius)
                        .foregroundStyle(.foreground.tertiary.opacity(0.5))
                        .foregroundStyle(.regularMaterial)
                        .background {
                            RoundedRectangle(cornerRadius: radius)
                                .stroke(.ultraThinMaterial.opacity(0.5), lineWidth: 0.5, antialiased: true)
                                .foregroundStyle(.clear)
                                .blur(radius: 0.1)
                        }
                }
            }
            .opacity(configuration.isPressed ? 0.5 : 1)
            .overlay {
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            withAnimation {
                                radius = proxy.size.height / 6
                            } completion: {
                                Logger.view.debug("SalientButtonStyle - Animation finished")
                            }
                        }
                }
            }
    }
}
