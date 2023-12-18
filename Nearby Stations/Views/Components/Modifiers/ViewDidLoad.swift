//
//  ViewDidLoad.swift
//  Nearby Stations
//
//  Created by Guillaume Coquard on 14/12/23.
//

import SwiftUI

struct ViewDidLoadModifier: ViewModifier {

    @State
    private var viewDidLoad: Bool = false

    private let action: () -> Void

    init(action: @escaping () -> Void ) {
        self.action = action
    }

    public func body(content: Content) -> some View {
        if !self.viewDidLoad {
            self.viewDidLoad = true
            self.action()
        }
        return content
    }
}

extension View {
    func onViewDidLoad(_ action: @escaping () -> Void) -> some View {
        modifier(ViewDidLoadModifier(action: action))
    }
}
