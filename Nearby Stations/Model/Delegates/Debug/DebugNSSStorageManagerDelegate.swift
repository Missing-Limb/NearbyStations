//
//  SharedStorageManagerDelegate.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 13/12/23.
//

import Foundation
import OSLog

extension NSSStorageManagerDelegate where Self == DebugNSSStorageManagerDelegate {
    static var debug: NSSStorageManagerDelegate {
        DebugNSSStorageManagerDelegate()
    }
}

class DebugNSSStorageManagerDelegate: NSSStorageManagerDelegate {
    func manager(_ storage: NSSStorage, didInit `self`: NSSStorage) {
        Logger.storage.debug("didInitNSSStorage")
        Logger.storageDelegate.debug("didInit")
    }
    func manager(_ storage: NSSStorage, willSetDelegate newValue: NSSStorageManagerDelegate?) {
        Logger.storageDelegate.debug("willSetDelegate")
    }
    func manager(_ storage: NSSStorage, didSetDelegate oldValue: NSSStorageManagerDelegate?) {
        Logger.storageDelegate.debug("didSetDelegate")
    }
    func manager(_ storage: NSSStorage, willSetMyStationName newValue: String?) {
        Logger.storageDelegate.debug("willSetMyStationName")
    }
    func manager(_ storage: NSSStorage, didSetMyStationName oldValue: String?) {
        Logger.storageDelegate.debug("didSetMyStationName")
    }
}
