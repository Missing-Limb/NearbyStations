//
//  NSSMapCameraPosition.swift
//  Nearby Stations
//
//  Created by Guillaume Coquard on 15/12/23.
//

import Foundation

enum NSSFocus: Int, Codable {
    case user       = 0
    case focused    = 1
    case listened   = 2
    case specific   = 3
}
