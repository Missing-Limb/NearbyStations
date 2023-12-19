//
//  Blur.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 11/12/23.
//

import SwiftUI

struct BlurModifier: ViewModifier {
    let blurValue: CGFloat

    func body(content: Content) -> some View {
        content
            .blur(radius: blurValue)
    }
}

extension AnyTransition {
    static var blur: AnyTransition {
        .modifier(
            active: BlurModifier(blurValue: 20),
            identity: BlurModifier(blurValue: 0)
        )
    }
}
