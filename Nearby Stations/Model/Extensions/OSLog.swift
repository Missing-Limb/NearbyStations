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
    static let view = Logger(subsystem: subsystem, category: "Views")
    static let model = Logger(subsystem: subsystem, category: "NSSModel()")
    static let modelDelegate = Logger(subsystem: subsystem, category: "NSSModelManagerDelegate")
    static let map = Logger(subsystem: subsystem, category: "NSSMap()")
    static let mapDelegate = Logger(subsystem: subsystem, category: "NSSMapManagerDelegate")
    static let station = Logger(subsystem: subsystem, category: "NSSStation()")
    static let stationDelegate = Logger(subsystem: subsystem, category: "NSSStationManagerDelegate")
    static let storage = Logger(subsystem: subsystem, category: "NSSStorage()")
    static let storageDelegate = Logger(subsystem: subsystem, category: "NSSStorageManagerDelegate")
    static let music = Logger(subsystem: subsystem, category: "NSSMusic()")
    static let musicDelegate = Logger(subsystem: subsystem, category: "NSSMusicManagerDelegate")
    static let tips = Logger(subsystem: subsystem, category: "NSSTips()")
    static let tipsDelegate = Logger(subsystem: subsystem, category: "NSSTipsManagerDelegate")
}
