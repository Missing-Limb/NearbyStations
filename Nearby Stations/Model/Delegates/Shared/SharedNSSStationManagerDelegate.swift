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
        DispatchQueue.main.async {
            Task {
                if let id = station.musicID {
                    do {
                        if let song = try await NSSMusic.getSongFrom(string: id),
                           song != station.song {
                            station.song = song
                        }
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                Logger.stationDelegate.debug("didSetMusicID")
            }
        }
    }

    override func manager(_ station: NSSStation, didSetSong oldValue: Song?) {
        DispatchQueue.main.async {
            Task {
                if let song = station.song {
                    if station.musicID != song.id.rawValue {
                        station.musicID = song.id.rawValue
                    }
                    station.artwork = await NSSMusic.getSongArtworkFrom(song: station.song)
                }
                Logger.stationDelegate.debug("didSetSong")
            }
        }
    }

}
