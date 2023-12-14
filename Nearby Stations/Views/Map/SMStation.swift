//
//  SMStation.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 12/12/23.
//

import SwiftUI

struct SMStation: View {

    @EnvironmentObject
    private var station: NSSStation

    @EnvironmentObject
    private var model: NSSModel

    @State
    private var amount: CGFloat = 0.0

    private let animation: Animation = .easeInOut(duration: 2).repeatForever(autoreverses: false)

    private var strokeColor: Color {
        return if station == NSSStation.default,
                  station == model.listened,
                  model.isPlaying,
                  !model.isLiveListening {
            .accent
        } else {
            .white
        }
    }

    private var annotationSize: CGFloat {
        self.model.focused == self.station ? 48.0 : 32.0
    }

    var body: some View {
        ZStack(alignment: .center) {

            if self.model.isPlaying
                && self.station == self.model.listened
                && (
                    self.station != NSSStation.default
                        || self.station == NSSStation.default && self.model.isBroadcasting
                ) {

                Circle()
                    .foregroundStyle(.clear)
                    .frame(width: 200, height: 200)

                Circle()
                    .foregroundStyle(.accent)
                    .frame(width: 200, height: 200)
                    .opacity(1 - amount)
                    .scaleEffect(amount)
                    .blur(radius: 10 * amount)
                    .onAppear {
                        DispatchQueue.main.async {
                            withAnimation(self.animation) {
                                self.amount = 1
                            }
                        }
                    }
                    .zIndex(0)
            }

            SImage(self.station, size: self.annotationSize)
                .clipShape(Circle())
                .overlay {
                    Circle()
                        .stroke( self.strokeColor, lineWidth: 3 )
                        .foregroundStyle(.clear)
                }
                .shadow(color: Color(white: 0, opacity: 0.2), radius: 10, y: 2)
                .onTapGesture {
                    DispatchQueue.main.async {
                        withAnimation {
                            self.model.focused = self.station
                        }
                    }
                }
                .zIndex(1)
        }

    }
}
