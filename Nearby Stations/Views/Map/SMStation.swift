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
        Logger.view.debug("SMStation - isDefault - computed")
        return station == .default
    }

    private var isFocused: Bool {
        Logger.view.debug("SMStation - isFocused - computed")
        return model.focused == station
    }

    private var isListened: Bool {
        Logger.view.debug("SMStation - isListened - computed")
        return model.listened == station
    }

    private var isRadiating: Bool {
        Logger.view.debug("SMStation - isRadiating - computed")
        return model.isPlaying && isListened &&
            (!isDefault || isDefault && model.isBroadcasting)
    }

    private var strokeColor: Color {
        return if isDefault,
                  isListened,
                  model.isPlaying,
                  !model.isLiveListening {
            .accent
        } else {
            .white
        }
    }

    private var animation: Animation = .easeInOut(duration: 2)

    private var annotationSize: CGFloat {
        isFocused ? 48.0 : 32.0
    }

    @State      private var amount: CGFloat = 0.0
    @State      private var model: NSSModel = .shared
    @Bindable   private var station: NSSStation

    init(_ station: NSSStation) {
        self.station = station
    }

    var body: some View {
        Button {
            DispatchQueue.main.async {
                withAnimation {
                    model.focused = station
                }
            }
        } label: {
            SImage(station, size: annotationSize)
                .clipShape(Circle())
                .overlay {
                    Circle()
                        .stroke(strokeColor, lineWidth: 3 )
                        .foregroundStyle(.clear)
                }
                .shadow(color: Color(white: 0, opacity: 0.2), radius: 10, y: 2)
        }
        .buttonStyle(BlankButton())
        .frame(width: 200, height: 200)
        .background {
            Circle()
                .foregroundStyle(.accent)
                .opacity(1 - amount)
                .scaleEffect(amount)
                .blur(radius: 10 * amount)
                .zIndex(0)
                .onAppear {
                    Logger.view.debug("SMStation - Button:background(Circle)")
                    DispatchQueue.global(qos: .userInteractive).async {
                        withAnimation( isRadiating
                                        ? animation.repeatForever(autoreverses: true)
                                        : animation
                        ) {
                            self.amount = 1
                        } completion: {
                            Logger.view.debug("Listening Wave Animation - Animation finished")
                        }
                    }
                }
        }
    }
}
