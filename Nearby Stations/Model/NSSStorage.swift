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

    public static let shared: NSSStorage = .init(delegate: .debug)

    @Published
    public var delegate: NSSStorageManagerDelegate? {
        willSet {
            self.delegate?.manager(self, willSetDelegate: newValue)
        }
        didSet {
            self.delegate?.manager(self, didSetDelegate: oldValue)
        }
    }

    @AppStorage("myStationName")
    public var myStationName: String = "My Station" {
        willSet {
            self.delegate?.manager(self, willSetMyStationName: newValue)
        }
        didSet {
            self.delegate?.manager(self, didSetMyStationName: oldValue)
        }
    }

    private init(delegate: NSSStorageManagerDelegate?) {
        super.init()
        Logger.storage.debug(" willInit - self: \(String(describing: self))")
        delegate?.manager(self, willInit: self)
        self.delegate = delegate
        self.delegate?.manager(self, didInit: self)
        Logger.storage.debug(" didInit - self: \(String(describing: self))")
    }

}
