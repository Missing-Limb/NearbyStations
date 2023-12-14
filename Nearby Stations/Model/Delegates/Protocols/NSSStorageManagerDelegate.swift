//
//  NSSStorageManagerDelegate.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 12/12/23.
//

import Foundation
import OSLog

protocol NSSStorageManagerDelegate: AnyObject {
    func manager(_ storage: NSSStorage, didInit `self`: NSSStorage)
    func manager(_ storage: NSSStorage, willSetDelegate newValue: NSSStorageManagerDelegate?)
    func manager(_ storage: NSSStorage, didSetDelegate oldValue: NSSStorageManagerDelegate?)
    func manager(_ storage: NSSStorage, willSetMyStationName newValue: String?)
    func manager(_ storage: NSSStorage, didSetMyStationName oldValue: String?)
}

extension NSSStorageManagerDelegate {
    func manager(_ storage: NSSStorage, didInit `self`: NSSStorage) {}
    func manager(_ storage: NSSStorage, willSetDelegate newValue: NSSStorageManagerDelegate?) {}
    func manager(_ storage: NSSStorage, didSetDelegate oldValue: NSSStorageManagerDelegate?) {}
    func manager(_ storage: NSSStorage, willSetMyStationName newValue: String?) {}
    func manager(_ storage: NSSStorage, didSetMyStationName oldValue: String?) {}
}
