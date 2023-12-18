//
//  NSSTips.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 11/12/23.
//

import SwiftUI
import TipKit
import OSLog

@Observable
final class NSSTips {

    public static let shared: NSSTips = .init()

    private init() {
        do {
            #if DEBUG
            try Tips.configure([
                .displayFrequency(.immediate),
                .datastoreLocation(.applicationDefault)
            ])
            #else
            try Tips.configure([
                .displayFrequency(.immediate),
                .datastoreLocation(.applicationDefault)
            ])
            #endif
        } catch {
            Logger.tips.error(" \(error.localizedDescription)")
        }
    }
}

// MARK: Broadcasting Tip Class & Extension
struct BroadcastingTip: Tip {
    var title: Text {
        Text("Broadcast")
    }

    var message: Text? {
        Text("Start broadcasting what you're listening to.")
    }

    var image: Image? {
        Image(systemName: "dot.radiowaves.left.and.right")
    }

    var rules: [Rule] = []

    var actions: [Action] {
        .init {
            Text("Add")
        }
    }

    var options: [TipOption] = [
        Tip.MaxDisplayCount(1)
    ]
}

extension NSSTips {
    static let broadcastingModeTip = BroadcastingTip.self
}

// MARK: Live Listening Tip Class & Extension
struct LiveListeningTip: Tip {
    var title: Text {
        Text("Live Listening")
    }

    var message: Text? {
        Text("Change your listened station to the closest one automatically.")
    }

    var image: Image? {
        Image(systemName: "livephoto.play")
    }

    var options: [TipOption] = [
        Tip.MaxDisplayCount(1)
    ]
}

extension NSSTips {
    static let liveListeningModeTip = LiveListeningTip.self
}
