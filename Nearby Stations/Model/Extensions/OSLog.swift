//
//  OSLog.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 13/12/23.
//

import Foundation
import OSLog

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    static let view = Logger(subsystem: subsystem, category: "view")
    static let model = Logger(subsystem: subsystem, category: "model")
    static let modelDelegate = Logger(subsystem: subsystem, category: "modeldelegate")
    static let map = Logger(subsystem: subsystem, category: "map")
    static let mapDelegate = Logger(subsystem: subsystem, category: "mapdelegate")
    static let station = Logger(subsystem: subsystem, category: "station")
    static let stationDelegate = Logger(subsystem: subsystem, category: "stationdelegate")
    static let storage = Logger(subsystem: subsystem, category: "storage")
    static let storageDelegate = Logger(subsystem: subsystem, category: "storagedelegate")
    static let music = Logger(subsystem: subsystem, category: "music")
    static let musicDelegate = Logger(subsystem: subsystem, category: "musicdelegate")
}
