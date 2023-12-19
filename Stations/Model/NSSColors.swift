//
//  Colors.swift
//  Nearby Stations
//
//  Created by Guillaume Coquard on 16/12/23.
//

import SwiftUI

enum NSSColors: String, Codable {
    case music = "Apple Music"
    case spotify = "Spotify"
    case podcasts = "Podcasts"
}

extension NSSColors {
    internal static func from(_ color: Self) -> Color {
        switch color {
        case .music:
            Color("Apple Music")
        case .spotify:
            Color("Spotify")
        case .podcasts:
            Color("Podcasts")
        }
    }
}
