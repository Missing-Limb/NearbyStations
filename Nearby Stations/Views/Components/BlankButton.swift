//
//  BlankButton.swift
//  Nearby Stations
//
//  Created by Guillaume Coquard on 14/12/23.
//

import SwiftUI

struct BlankButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}
