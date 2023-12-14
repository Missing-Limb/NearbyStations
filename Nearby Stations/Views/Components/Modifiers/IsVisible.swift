//
//  IsVisibleModifier.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 11/12/23.
//

import SwiftUI

struct IsVisible: ViewModifier {

    var condition: Bool = true

    func body(content: Content) -> some View {
        if condition {
            content
        } else {
            EmptyView()
        }
    }
}

extension View {
    func isVisible(if condition: Bool) -> some View {
        modifier(IsVisible(condition: condition))
    }

    func isVisible(if condition: Binding<Bool>) -> some View {
        modifier(IsVisible(condition: condition.wrappedValue))
    }
}
