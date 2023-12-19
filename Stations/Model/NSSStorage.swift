//
//  NSSStorage.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 11/12/23.
//

import Foundation
import SwiftUI
import OSLog

final class NSSStorage: NSObject, ObservableObject {

    public static let shared: NSSStorage = .init()

    @AppStorage("myID")
    public var myID: String = UUID().uuidString

    @AppStorage("selectedAccent")
    public var selectedAccent: String = "Apple Music"

    @AppStorage("connectedServices")
    public var connectedServices: NSSServices.RawValue = "Apple Music"

    @AppStorage("myStationName")
    public var myStationName: String = "My Station"

    override private init() {}

}
