//
//  ShareMusicManagerDelegate.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 13/12/23.
//

import Foundation
import OSLog

extension NSSMusicManagerDelegate where Self == DebugNSSMusicManagerDelegate {
    static var debug: NSSMusicManagerDelegate {
        DebugNSSMusicManagerDelegate()
    }
}

class DebugNSSMusicManagerDelegate: NSSMusicManagerDelegate {
    func manager(_ music: NSSMusic, willInit `self`: NSSMusic) {
        Logger.musicDelegate.debug("willInit - self: \(String(describing: `self`))")
    }
    func manager(_ music: NSSMusic, didInit `self`: NSSMusic) {
        Logger.musicDelegate.debug("didInit - self: \(String(describing: `self`))")
    }
    func manager(_ music: NSSMusic, willSetDelegate newValue: NSSMusicManagerDelegate?) {
        Logger.musicDelegate.debug("willSetDelegate")
    }
    func manager(_ music: NSSMusic, didSetDelegate oldValue: NSSMusicManagerDelegate?) {
        Logger.musicDelegate.debug("didSetDelegate")
    }
    func manager(_ music: NSSMusic, willSetAuthorized newValue: Bool) {
        Logger.musicDelegate.debug("willSetAuthorized")
    }
    func manager(_ music: NSSMusic, didSetAuthorized oldValue: Bool) {
        Logger.musicDelegate.debug("didSetAuthorized")
    }
    func manager(_ music: NSSMusic, willSetNeedsToSubscribe newValue: Bool) {
        Logger.musicDelegate.debug("willSetNeedsToSubscribe")
    }
    func manager(_ music: NSSMusic, didSetNeedsToSubscribe oldValue: Bool) {
        Logger.musicDelegate.debug("didSetNeedsToSubscribe")
    }
}
