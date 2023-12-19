//
//  NSSStyle.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 10/12/23.
//

import SwiftUI

@Observable
final class NSSStyle {

    public static let shared: NSSStyle = .init()

    public var spacing: CGFloat = 12
    public var stationMargin: CGFloat = 24
    public var scrollViewHeight: CGFloat = 176

    private init() {}
}
