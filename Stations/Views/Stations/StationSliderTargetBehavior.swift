//
//  StationSliderTargetBehavior.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 11/12/23.
//

import SwiftUI

struct StationSliderTargetBehavior: ScrollTargetBehavior {
    func updateTarget(_ target: inout ScrollTarget, context: TargetContext) {
        ViewAlignedScrollTargetBehavior(limitBehavior: .always).updateTarget(&target, context: context)
        target.rect.origin.x = (CGFloat(Int(target.rect.origin.x / target.rect.width)) - 0.0) * target.rect.width
    }
}

extension ScrollTargetBehavior where Self == StationSliderTargetBehavior {
    static var stationAlignedBehavior: StationSliderTargetBehavior {
        StationSliderTargetBehavior()
    }
}
