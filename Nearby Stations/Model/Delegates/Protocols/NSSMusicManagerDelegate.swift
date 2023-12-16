//
//  NSSMusicManagerDelegate.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 13/12/23.
//

import Foundation
import OSLog

protocol NSSMusicManagerDelegate: AnyObject {
    func manager(_ music: NSSMusic, willInit `self`: NSSMusic)
    func manager(_ music: NSSMusic, didInit `self`: NSSMusic)
    func manager(_ music: NSSMusic, willSetDelegate newValue: NSSMusicManagerDelegate?)
    func manager(_ music: NSSMusic, didSetDelegate oldValue: NSSMusicManagerDelegate?)
    func manager(_ music: NSSMusic, willSetAuthorized newValue: Bool)
    func manager(_ music: NSSMusic, didSetAuthorized oldValue: Bool)
    func manager(_ music: NSSMusic, willSetNeedsToSubscribe newValue: Bool)
    func manager(_ music: NSSMusic, didSetNeedsToSubscribe oldValue: Bool)
}

extension NSSMusicManagerDelegate {
    func manager(_ music: NSSMusic, willInit `self`: NSSMusic) {}
    func manager(_ music: NSSMusic, didInit `self`: NSSMusic) {}
    func manager(_ music: NSSMusic, willSetDelegate newValue: NSSMusicManagerDelegate?) {}
    func manager(_ music: NSSMusic, didSetDelegate oldValue: NSSMusicManagerDelegate?) {}
    func manager(_ music: NSSMusic, willSetAuthorized newValue: Bool) {}
    func manager(_ music: NSSMusic, didSetAuthorized oldValue: Bool) {}
    func manager(_ music: NSSMusic, willSetNeedsToSubscribe newValue: Bool) {}
    func manager(_ music: NSSMusic, didSetNeedsToSubscribe oldValue: Bool) {}
}
