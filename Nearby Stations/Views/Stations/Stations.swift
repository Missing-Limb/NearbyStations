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

    @EnvironmentObject
    private var model: NSSModel

    var body: some View {
        if self.model.areStationsInitialized {
            ScrollViewReader { proxy in
                ScrollView(.horizontal) {
                    LazyHStack(alignment: .bottom, spacing: 0) {
                        ForEach(self.model.sortedStations, content: SView.init)
                    }
                    .scrollTargetLayout()
                }
                .scrollPosition(id: self.$model.focusedID, anchor: .center)
                .scrollIndicators(.never)
                .scrollTargetBehavior(.stationAlignedBehavior)
                .scrollClipDisabled()
                .contentMargins(.horizontal, model.style.stationMargin)
                .sensoryFeedback(.selection, trigger: self.model.focused)
                .frame(height: model.style.scrollViewHeight)
                .onAppear {
                    model.scrollViewProxy = proxy
                    //                self.stations = self.model.sortedStations
                }
            }
        }

        //        .onChange(of: self.model.location) {
        //            self.stations = self.model.sortedStations
        //        }
        //        .onChange(of: focusedID) {
        //            DispatchQueue.main.async {
        //                withAnimation {
        //                    if focusedID != self.model.focusedID {
        //                        self.model.focusedID = focusedID
        //                    }
        //                }
        //            }
        //        }
        //        .onChange(of: self.model.focused) {
        //            DispatchQueue.main.async {
        //                withAnimation {
        //                    if let focused = self.model.focused,
        //                       self.focusedID != focused.id  {
        //                        self.focusedID = focused.id
        //                    }
        //                }
        //            }
        //        }
        //        .onChange(of: self.model.stations) {
        //            self.stations = self.model.sortedStations
        //            if focusedID != nil && self.model.stations.contains(focusedID) {
        //                self.model.focusedID = focusedID
        //            } else if self.model.isLiveListening && self.model.stations.count > 0 {
        //                self.focusedID = self.model.sortedStations.firstDifferent?.id ?? NSSStation.default.id
        //            } else {
        //                self.focusedID = NSSStation.default.id
        //            }
        //        }
    }
}
