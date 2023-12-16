//
//  MusicHelper.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 07/12/23.
//

import Foundation
import MusicKit
import OSLog

@Observable
final class NSSMusic {

    public static let shared: NSSMusic = .init()

    public static var authorized: Bool {
        NSSMusic.shared.authorized
    }

    public static var needsToSubscribe: Bool {
        NSSMusic.shared.needsToSubscribe
    }

    public static func requestAuthorization() async -> Bool {
        await MusicAuthorization.request() == .authorized
    }

    public static func needsToSubscribe() async -> Bool {
        await MusicSubscription.subscriptionUpdates.first { $0.canPlayCatalogContent } != nil
    }

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
        Logger.music.info(".getSongFrom(String) - NSSMusic.authorized: \(NSSMusic.authorized)")
        return nil
    }

    public static func getSongArtworkFrom(song: Song?) async -> Data? {
        if NSSMusic.authorized {
            if let url = song?.artwork?.url(width: 1024, height: 1024) {
                do {
                    return try await withCheckedThrowingContinuation { continuation in
                        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
                            if let error = error {
                                continuation.resume(throwing: error)
                            } else if let data = data {
                                Logger.music.info(".getSongArtworkFrom(song:Song) - continuation.resume(returning: data)")
                                continuation.resume(returning: data)
                            } else {
                                Logger.music.info(".getSongArtworkFrom(song:Song) - continuation.resume(returning: nil)")
                                continuation.resume(returning: nil)
                            }
                        }
                        task.resume()
                    }
                } catch {
                    Logger.music.error(".getSongArtworkFrom(song:Song) - error: \(error.localizedDescription)")
                }
            }
            Logger.music.info(".getSongArtworkFrom(song:Song) - song?.artwork?.url - song: \"\(song?.id.rawValue ?? "")\"")
        }
        Logger.music.info(".getSongArtworkFrom(song:Song) - NSSMusic.authorized: \(NSSMusic.authorized)")
        return nil
    }

    public private(set) var authorized: Bool = false {
        didSet {
            NotificationCenter.default.post(name: .accessUpdate, object: nil)
            Task {
                self.needsToSubscribe = await NSSMusic.needsToSubscribe()
            }
        }
    }

    /// No private set because i have to give away control to the system through musicSubscriptionOffer model sheet
    public var needsToSubscribe: Bool = true

    private init() {
        Task {
            await self.requestAuthorization()
        }
    }

    private func updateAuthorization(_ value: Bool) {
        self.authorized = value
        Logger.music.debug(" .updateAuthorization - authorized - set: \(self.authorized)")
    }

    public func requestAuthorization() async {
        self.updateAuthorization(await NSSMusic.requestAuthorization())
        Logger.music.debug(" .requestAuthorization")
    }
}
