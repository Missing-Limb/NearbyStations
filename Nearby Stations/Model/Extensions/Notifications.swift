//
//  Notifications.swift
//  Nearby Stations
//
//  Created by Guillaume Coquard on 15/12/23.
//

import Foundation

extension Notification.Name {
    static let music = Notification.Name("music")
    static let map = Notification.Name("map")
    static let locationUpdate = Notification.Name("locationUpdate")
    static let locationUpdated = Notification.Name("locationUpdated")
    static let cameraUpdate = Notification.Name("cameraUpdate")
    static let focusUpdate = Notification.Name("focusUpdate")
    static let noMusicToPlay = Notification.Name("noMusicToPlay")
}

extension NotificationCenter {
    static let view: NotificationCenter = .init()
    static let model: NotificationCenter = .init()
}

extension NotificationCenter {
    static let access: NotificationCenter = .init()
}

extension Notification.Name {
    static let accessUpdate = Notification.Name("accessUpdate")
    static let accessGranted = Notification.Name("accessGranted")
}

// MARK: Stations Related Notification Center
extension NotificationCenter {
    static let stations: NotificationCenter = .init()
}

extension Notification.Name {
    static let startUpdatingStations = Notification.Name("startUpdatingStations")
    static let stationsInitialized = Notification.Name("stationsInitialized")
    static let stationsUpdated = Notification.Name("stationsUpdated")
    static let stationsRetrieved = Notification.Name("stationsRetrieved")
}
