//
//  SMStation.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 12/12/23.
//

import SwiftUI
import OSLog

struct SMStation: View {

    private var isDefault: Bool {
        station == .default
    }

    private var isFocused: Bool {
        model.focused == station
    }

    private var isListened: Bool {
        model.listened == station
    }

    private var shouldBeHighlighted: Bool {
        isListened && model.isPlaying
    }

    private var isRadiating: Bool {
        model.isPlaying && isListened && (!isDefault || isDefault && model.isBroadcasting)
    }

    private var animation: Animation {
        isRadiating ? .easeInOut(duration: 2).repeatForever(autoreverses: false) : .easeInOut(duration: 2)
    }

    private var annotationSize: CGFloat {
        isFocused ? 64.0 : 32.0
    }

    @State      private var amount: CGFloat = 0.0
    @State      private var model: NSSModel = .shared
    @Bindable   private var station: NSSStation

    init(_ station: NSSStation) {
        self.station = station
    }

    var body: some View {
        Button {
            withAnimation { model.focused = station }
        } label: {
            SImage(station, size: annotationSize)
                .clipShape(Circle())
                .background {
                    ZStack {
                        Circle()
                            .stroke(.white, lineWidth: 8)

                        Circle()
                            .stroke(Color(white: 0.1, opacity: 0.5), lineWidth: 0.5)
                    }
                }
                .padding()
                .background {
                    if shouldBeHighlighted {
                        Circle()
                            .foregroundStyle(.tint)
                    } else {
                        Circle()
                            .foregroundStyle(.clear)
                    }
                }
        }
        .buttonStyle(BlankButton())
        .frame(width: 300, height: 300)
        .background {
            Circle()
                .foregroundStyle(.tint)
                .opacity(isRadiating ? 1 - amount : 0)
                .scaleEffect(amount)
                .blur(radius: 10 * amount)
                .zIndex(-10)
                .onAppear {
                    withAnimation(animation) { amount = 1.0 }
                }
        }
    }

}
