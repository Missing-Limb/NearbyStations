//
//  SharedModelManagerDelegate.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 13/12/23.
//

import SwiftUI
import CoreLocation
import Collections
import OSLog

extension NSSModelManagerDelegate where Self == SharedNSSModelManagerDelegate {
    static var shared: NSSModelManagerDelegate {
        SharedNSSModelManagerDelegate()
    }
}

protocol SharedNSSModelManagerDelegateProtocol: DebugNSSModelManagerDelegateProtocol {}

extension SharedNSSModelManagerDelegateProtocol {}

final class SharedNSSModelManagerDelegate: SharedNSSModelManagerDelegateProtocol {}
