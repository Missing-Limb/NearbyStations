//
//  ContentView.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 07/12/23.
//

import SwiftUI
import OSLog

struct NSSMainView: View {

    @EnvironmentObject
    private var model: NSSModel

    var body: some View {

        ZStack {

            SMView()
                .ignoresSafeArea(.all)
                .safeAreaPadding(.bottom, 24)
                .onTapGesture {
                    Logger.view.debug("NSSMainView - body - onTapGesture - start")
                    DispatchQueue.main.async {
                        withAnimation {
                            model.allStations.first(where: { $0 == model.focused && $0.open })?.open = false
                            Logger.view.debug("NSSMainView - body - onTapGesture - end")
                        }
                    }
                }

            VStack(alignment: .center, spacing: 0) {
                HStack(alignment: .top, spacing: 0) {
                    SProfile()
                    Spacer()
                    SMControls()
                }
                .safeAreaPadding(.top, 24)
                .padding(.horizontal, 32)
                Spacer()
            }

            VStack(alignment: .center, spacing: 0) {
                Spacer()
                Stations()
            }
            .padding(.bottom, 16)

        }
    }
}
