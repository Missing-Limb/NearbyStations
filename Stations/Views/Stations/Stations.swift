//
//  Stations.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 07/12/23.
//

import SwiftUI
import Collections
import OrderedCollections

struct Stations: View {

    @Environment(NSSStyle.self)
    private var style: NSSStyle

    @State
    private var model: NSSModel = .shared

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                LazyHStack(alignment: .bottom, spacing: 0) {
                    if model.areStationsInitialized {
                        ForEach(model.allClosestStations, content: SView.init)
                    } else {
                        ForEach([NSSStation.default], content: SView.init)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollPosition(id: $model.focusedID, anchor: .center)
            .scrollIndicators(.never)
            .scrollTargetBehavior(.viewAligned)
            .scrollClipDisabled()
            .contentMargins(.horizontal, style.stationMargin)
            .sensoryFeedback(.selection, trigger: model.focused)
            .frame(height: style.scrollViewHeight)
            .onAppear {
                model.scrollViewProxy = proxy
            }
        }
    }
}
