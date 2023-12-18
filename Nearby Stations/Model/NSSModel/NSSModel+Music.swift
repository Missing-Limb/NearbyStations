//
//  NSSModel+Music.swift
//  Nearby Stations
//
//  Created by Guillaume Coquard on 15/12/23.
//

import Foundation
import SwiftUI
import MusicKit

// MARK: Play
extension NSSModel {

    public func play() async {
        NSSMusic.play()
    }

    public func play(song: Song?) async {
        await self.play()
    }

    public func play(song: NSSSong?) async {
        await self.play()
    }

    public func play(string id: String) async {
        await self.play(song: await NSSMusic.getSongFrom(string: id))
    }

    public func play(MusicItemID id: MusicItemID) async {
        await self.play(song: await NSSMusic.getSongFrom(musicItemID: id))
    }

    public func play(station: NSSStation?) async {
        if let station = station {
            await self.play(song: station.song)
        }
    }

}

// MARK: Pause
extension NSSModel {
    public func pause() {

    }
}
