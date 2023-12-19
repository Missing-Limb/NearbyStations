//
//  NSSModel+ScrollViewPosition.swift
//  Nearby Stations
//
//  Created by Guillaume Coquard on 15/12/23.
//

import Foundation
import SwiftUI

// MARK: Changing ScrollViewProxy Position
extension NSSModel {

    private func updateScrollPosition() {
        if let proxy = self.scrollViewProxy {
            withAnimation {
                proxy.scrollTo(NSSStation.default)
            }
        }
    }

    private func updateScrollPosition(to target: UUID?) {
        if let proxy = self.scrollViewProxy, let target = target {
            proxy.scrollTo(target)
        }
    }

    private func updateScrollPosition(to target: NSSStation? = nil) {
        self.updateScrollPosition(to: target?.id)
    }

    public func scroll(to target: NSSFocus, _ station: NSSStation? = nil) {
        switch target {
        case .focused:
            self.updateScrollPosition(to: self.focused)
        case .listened:
            self.updateScrollPosition(to: self.listened)
        case .specific:
            self.updateScrollPosition(to: station)
        default:
            self.updateScrollPosition()
        }
    }
}
