//
//  ToggleButton.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 10/12/23.
//

import SwiftUI
import TipKit

struct ToggleButton<Content: View>: View {

    var state: Binding<Bool>
    var action: () -> Void = {}
    var label: () -> Content

    init(_ state: Binding<Bool>, label: @escaping () -> Content) {
        self.state = state
        self.label = label
    }

    var body: some View {
        Button {
            DispatchQueue.main.async {
                withAnimation {
                    state.wrappedValue.toggle()
                }
            }
        } label: {
            Group {
                HStack(alignment: .center, spacing: 0) {
                    Image(systemName: "plus")
                        .hidden()
                        .accessibilityHidden(true)
                }
                .padding()
                .background( state.wrappedValue ? .accent : .clear)
                .overlay {
                    self.label()
                        .labelStyle(.iconOnly)
                        .foregroundStyle( state.wrappedValue ? .white : .primary)
                }
            }
            .font(.title3)
            .fontWeight(.bold)
        }
    }
}
