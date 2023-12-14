//
//  NSSModel+NSSMusicManagerDelegate.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 13/12/23.
//

import Foundation
import OSLog

extension NSSModel: NSSMusicManagerDelegate {

    func manager(_ music: NSSMusic, didInit `self`: NSSMusic) {
        DispatchQueue.main.async {
            Task {
                await music.requestAuthorization()
                Logger.music.debug("didInitNSSMusic")
                Logger.musicDelegate.debug("didInit")
            }
        }
    }

    func manager(_ music: NSSMusic, didSetAuthorized oldValue: Bool) {
        if music.authorized {
            self.isMusicAccessible = true
        }
        Logger.musicDelegate.debug("didSetAuthorized - isMusicAccessible - set: \(self.isMusicAccessible)")
    }

}
