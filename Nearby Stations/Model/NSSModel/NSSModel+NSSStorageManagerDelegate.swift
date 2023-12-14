//
//  NSSModel+sss.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 13/12/23.
//

import Foundation
import OSLog

extension NSSModel: NSSStorageManagerDelegate {
    func manager(_ storage: NSSStorage, didSetMyStationName oldValue: String?) {
        NSSStation.default.name = storage.myStationName
        Logger.storageDelegate.debug("didSetMyStationName - NSSStation.default.name - set: \(storage.myStationName)")
    }
}
