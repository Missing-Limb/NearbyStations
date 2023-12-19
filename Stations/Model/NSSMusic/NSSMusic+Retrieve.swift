//
//  NSSMusic+Retrieve.swift
//  Nearby Stations
//
//  Created by Guillaume Coquard on 18/12/23.
//

import Foundation
import MusicKit
import OSLog

extension NSSMusic {

    public static func getCurrentSongId() -> String? {
        return SystemMusicPlayer.shared.queue.currentEntry?.id ?? nil
    }

    public static func getSongFrom(musicItemID id: MusicItemID) async -> Song? {
        if NSSMusic.authorized {
            do {
                return try await MusicCatalogResourceRequest<Song>(
                    matching: \.id,
                    equalTo: id
                ).response().items.first ?? nil
            } catch {
                Logger.music.error(".getSongFrom(MusicItemID) - error: \(error.localizedDescription)")
            }
        }
        Logger.music.info(".getSongFrom(MusicItemID) - NSSMusic.authorized: \(NSSMusic.authorized)")
        return nil
    }

    public static func getSongFrom(string id: String) async -> Song? {
        if NSSMusic.authorized {
            do {
                return try await MusicCatalogResourceRequest<Song>(
                    matching: \.id,
                    equalTo: MusicItemID(rawValue: id)
                ).response().items.first ?? nil
            } catch {
                Logger.music.error(".getSongFrom(String) - error: \(error.localizedDescription)")
            }
        }
        return nil
    }

    public static func getSongArtworkFrom(song: Song?) async -> Data? {
        if NSSMusic.authorized {
            if let artwork = song?.artwork {
                let width: Int = artwork.maximumWidth
                let height: Int = artwork.maximumHeight
                if let url = artwork.url(width: width, height: height) {
                    do {
                        return try await withCheckedThrowingContinuation { continuation in
                            let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
                                if let error = error {
                                    continuation.resume(throwing: error)
                                } else if let data = data {
                                    continuation.resume(returning: data)
                                } else {
                                    continuation.resume(returning: nil)
                                }
                            }
                            task.resume()
                        }
                    } catch {
                        Logger.music.error(".getSongArtworkFrom(song:Song) - error: \(error.localizedDescription)")
                    }
                }
            }
            Logger.music.info(".getSongArtworkFrom(song:Song) - song?.artwork?.url - song: \"\(song?.id.rawValue ?? "")\"")
        }
        return nil
    }

    public static func getSongArtworkFrom(url: URL?) async -> Data? {
        if NSSMusic.authorized {
            if let url = url {
                do {
                    return try await withCheckedThrowingContinuation { continuation in
                        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
                            if let error = error {
                                continuation.resume(throwing: error)
                            } else if let data = data {
                                continuation.resume(returning: data)
                            } else {
                                continuation.resume(returning: nil)
                            }
                        }
                        task.resume()
                    }
                } catch {
                    Logger.music.error(".getSongArtworkFrom(song:Song) - error: \(error.localizedDescription)")
                }
            }
            Logger.music.info(".getSongArtworkFrom(url:URL) - url: \(String(describing: url))")
        }
        return nil
    }
}
