//
//  SharedNSSStationManagerDelegate.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 13/12/23.
//

import Foundation
import MusicKit
import OSLog

extension NSSStationManagerDelegate where Self == SharedNSSStationManagerDelegate {
    static var shared: NSSStationManagerDelegate {
        SharedNSSStationManagerDelegate()
    }
}

protocol SharedNSSStationManagerDelegateProtocol: DebugNSSStationManagerDelegateProtocol {}

extension SharedNSSStationManagerDelegateProtocol {}

final class SharedNSSStationManagerDelegate: SharedNSSStationManagerDelegateProtocol {}
