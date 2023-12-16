//
//  ToggleButton.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 10/12/23.
//

import SwiftUI
import OSLog

struct ToggleButton<Content: View>: View {

    var state: Binding<Bool>
    var animated: Bool = false
    var action: () -> Void = {}
    var label: (() -> Content)?
    var otherLabel: (() -> Content)?
    var completion: (() -> Void)?

    init(
        _ state: Binding<Bool>,
        label: @escaping () -> Content
    ) {
        self.state = state
        self.label = label
    }

    init(
        _ state: Binding<Bool>,
        label: @escaping () -> Content,
        completion: @escaping () -> Void
    ) {
        self.state = state
        self.label = label
        self.completion = completion
    }

    init(
        _ state: Binding<Bool>,
        animated: Bool,
        label: @escaping () -> Content,
        completion: @escaping () -> Void
    ) {
        self.state = state
        self.label = label
        self.otherLabel = label
        self.animated = animated
        self.completion = completion
    }

    init(
        _ state: Binding<Bool>,
        enabledLabel: @escaping () -> Content,
        disabledLabel: @escaping () -> Content,
        completion: @escaping () -> Void
    ) {
        self.state = state
        self.label = enabledLabel
        self.otherLabel = disabledLabel
        self.completion = completion
    }

    init(
        _ state: Binding<Bool>,
        animated: Bool,
        enabledLabel: @escaping () -> Content,
        disabledLabel: @escaping () -> Content,
        completion: @escaping () -> Void
    ) {
        self.state = state
        self.label = enabledLabel
        self.otherLabel = disabledLabel
        self.animated = animated
        self.completion = completion
    }

    var body: some View {
        Button {
            if animated {
                DispatchQueue.global(qos: .userInteractive).async {
                    withAnimation {
                        state.wrappedValue.toggle()
                    } completion: {
                        completion?()
                    }
                }
            } else {
                state.wrappedValue.toggle()
            }
        } label: {
            Group {
                HStack(alignment: .center, spacing: 0) {
                    Image(systemName: "button.programmable")
                        .hidden()
                        .accessibilityHidden(true)
                }
                .padding()
                .background( state.wrappedValue ? .accent : .clear)
                .overlay {
                    if let label = label {
                        if let otherLabel = otherLabel {
                            if state.wrappedValue {
                                label()
                                    .labelStyle(.iconOnly)
                                    .foregroundStyle( state.wrappedValue ? .white : .primary)
                            } else {
                                otherLabel()
                                    .labelStyle(.iconOnly)
                                    .foregroundStyle( state.wrappedValue ? .white : .primary)
                            }
                        } else {
                            label()
                                .labelStyle(.iconOnly)
                                .foregroundStyle( state.wrappedValue ? .white : .primary)
                        }
                    } else {
                        Label("Button", systemImage: "button.programmable")
                            .labelStyle(.iconOnly)
                            .foregroundStyle( state.wrappedValue ? .white : .primary)
                    }
                }
            }
            .font(.title3)
            .fontWeight(.bold)
        }
    }
}
