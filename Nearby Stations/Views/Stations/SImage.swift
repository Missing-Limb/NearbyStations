//
//  StationImageView.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 10/12/23.
//

import SwiftUI

struct SImage: View {

    let station: NSSStation
    let size: CGFloat

    init(_ station: NSSStation, size: CGFloat) {
        self.station = station
        self.size = size
    }

    var body: some View {
        Group {
            if let artwork = station.artwork {
                if let uiImage = UIImage(data: artwork) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: size, height: size)
                }
            } else {
                Rectangle()
                    .foregroundStyle(.regularMaterial)
            }
        }
        .frame(width: size, height: size)
    }
}
