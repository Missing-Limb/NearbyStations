//
//  DefaultNSSMusicManagerDelegate.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 13/12/23.
//

extension NSSMusicManagerDelegate where Self == DefaultNSSMusicManagerDelegate {
    static var `default`: NSSMusicManagerDelegate {
        DefaultNSSMusicManagerDelegate()
    }
}

class DefaultNSSMusicManagerDelegate: NSSMusicManagerDelegate {}
