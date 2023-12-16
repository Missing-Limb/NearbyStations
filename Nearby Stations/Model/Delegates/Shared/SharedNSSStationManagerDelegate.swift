//
//  SharedNSSStationManagerDelegate.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 13/12/23.
//

import Foundation
import MusicKit
import OSLog

extension NSSStationManagerDelegate where Self == SharedNSSStationManagerDelegate {
    static var shared: NSSStationManagerDelegate {
        SharedNSSStationManagerDelegate()
    }
}

final class SharedNSSStationManagerDelegate: DebugNSSStationManagerDelegate {

    override func manager(_ station: NSSStation, didSetMusicID oldValue: String?) {
        if let id = station.musicID {
            Task {
                if let song = await NSSMusic.getSongFrom(string: id), song != station.song {
                    station.song = song
                }
            }
        }
        Logger.stationDelegate.debug(" didSetMusicID")
    }

    override func manager(_ station: NSSStation, didSetArtwork oldValue: Data?) {
        if station.artwork == nil {
            Task {
                station.artwork = await NSSMusic.getSongArtworkFrom(song: station.song)
            }
        }
        Logger.stationDelegate.debug(" didSetArtwork")
    }

    override func manager(_ station: NSSStation, didSetSong oldValue: Song?) {
        guard let song = station.song else {
            Logger.stationDelegate.info(" didSetSong - song is nil")
            return
        }

        if station.musicID != song.id.rawValue {
            station.musicID = song.id.rawValue
        }

        Task {
            station.artwork = await NSSMusic.getSongArtworkFrom(song: station.song)
        }

        Logger.stationDelegate.debug(" didSetSong")
    }

}
