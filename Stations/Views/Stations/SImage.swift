//
//  StationImageView.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 10/12/23.
//

import SwiftUI

struct SImage: View {

    @Bindable
    var station: NSSStation

    let size: CGFloat

    init(_ station: NSSStation, size: CGFloat) {
        self.station = station
        self.size = size
    }

    var body: some View {
        Group {
            if let image = self.station.artwork {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: size, height: size)
            } else {
                Rectangle()
                    .foregroundStyle(.regularMaterial)
            }
        }
        .frame(width: size, height: size)
    }
}
