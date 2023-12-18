//
//  PermissionButton.swift
//  Nearby Stations
//
//  Created by Guillaume Coquard on 16/12/23.
//

import SwiftUI

struct PermissionButton: View {

    private let label: String
    private let action: () -> Void
    private var status: Binding<Bool>

    private func statusImage(_ status: Bool) -> String {
        status ? "checkmark.circle.fill" : "circle"
    }

    private func statusWord(_ status: Bool) -> String {
        status ? "Enabled" : "Disabled"
    }

    init(_ label: String, status: Binding<Bool>, _ action: @escaping @Sendable () -> Void) {
        self.label = label
        self.action = action
        self.status = status
    }

    private var innerBody: some View {
        HStack {
            Text(label)
                .fontWeight(.medium)
                .foregroundStyle(.foreground)
                .accessibilityHidden(true)
            Spacer()
            Image(systemName: statusImage(status.wrappedValue))
                .font(.title3)
                .fontWeight(.bold)
                .foregroundStyle(.tint)
                .accessibilityHidden(true)
        }
        .padding()
        .background(.ultraThinMaterial.opacity(0.5))
        .background(.foreground.quinary.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    var body: some View {
        Group {
            if status.wrappedValue {
                innerBody
                    .accessibilityLabel("\(label) \(statusWord(status.wrappedValue))")
            } else {
                Button(action: action) {
                    innerBody
                }
                .buttonStyle(.plain)
                .accessibilityLabel("\(label) \(statusWord(status.wrappedValue))")
            }
        }
        .accessibilityAddTraits(.isButton)
    }
}
