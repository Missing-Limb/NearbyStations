//
//  ContentView.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 07/12/23.
//

import SwiftUI
import OSLog

struct NSSMainView: View {

    @Environment(NSSModel.self)
    private var model: NSSModel

    var body: some View {
        SMView()
            .simultaneousGesture(
                TapGesture()
                    .onEnded(model.closePreviouslyFocusedStation)
            )
            .ignoresSafeArea(.all)
            .safeAreaInset(edge: .top, alignment: .trailing) {
                HStack(alignment: .top) {
                    SProfile()
                    Spacer()
                    SMControls()
                }
                .padding(.horizontal, 32)
                .padding(.top)
            }
            .safeAreaInset(edge: .bottom) {
                Stations()
                    .padding(.bottom)
            }
    }
}
