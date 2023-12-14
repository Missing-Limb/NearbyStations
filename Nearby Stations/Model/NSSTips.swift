//
//  NSSTips.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 11/12/23.
//

import SwiftUI
import TipKit

final class NSSTips {

    public static let shared: NSSTips = .init()

    static let broadcastingModeTip = BroadcastingTip.self
    static let liveListeningModeTip = LiveListeningTip.self

    init() {
        DispatchQueue.main.async {
            try? Tips.configure([
                .displayFrequency(.monthly),
                .datastoreLocation(.applicationDefault)
            ])
        }
    }
}

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
}

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
}
