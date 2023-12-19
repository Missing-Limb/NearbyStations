//
//  NSSModel+Music.swift
//  Nearby Stations
//
//  Created by Guillaume Coquard on 15/12/23.
//

import Foundation
import SwiftUI
import MusicKit
import OSLog

// MARK: Play
extension NSSModel {

    public func play() async {
        await NSSMusic.shared.play()
    }

    public func play(
        song: Song?,
        at playbackTime: TimeInterval? = 0,
        savedAt time: TimeInterval? = -1
    ) async {
        if let song = song {
            await NSSMusic.shared.play(song: song, at: playbackTime ?? 0, savedAt: time ?? -1)
        }
    }

    public func play(string id: String) async {
        await self.play(song: await NSSMusic.getSongFrom(string: id))
    }

    public func play(MusicItemID id: MusicItemID) async {
        await self.play(song: await NSSMusic.getSongFrom(musicItemID: id))
    }

    public func play(station: NSSStation?) async {
        if let station = station,
           let song = station.song {
            Logger.music.info("Reached")
            await NSSMusic.shared.play(
                song: song,
                at: station.playbackTime ?? 0,
                savedAt: station.saveTime ?? -1
            )
        }
    }

}

// MARK: Pause
extension NSSModel {
    public func pause() {
        NSSMusic.shared.pause()
    }
}
