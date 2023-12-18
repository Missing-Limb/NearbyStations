//
//  MusicHelper.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 07/12/23.
//

import Foundation
import UIKit
import SwiftUI
import MusicKit
import MediaPlayer
import OSLog

@Observable
final class NSSMusic {

    typealias AuthorizationStatus = MusicAuthorization.Status
    typealias SubscriptionStatus = (Bool, MusicSubscription.Updates.Element?)

    public static let shared: NSSMusic = .init()

    public static var authorized: Bool {
        NSSMusic.shared.authorized
    }

    public static var needsToSubscribe: Bool {
        NSSMusic.shared.needsToSubscribe
    }

    public internal(set) var authorized: Bool = false {
        didSet {
            NotificationCenter.default.post(name: .accessUpdate, object: nil)
        }
    }

    /// No private set because i have to give away control to the system through musicSubscriptionOffer model sheet
    public var needsToSubscribe: Bool = false

    private init() {
        Task {
            self.updateAuthorization(
                NSSMusic.checkCurrentStatus(),
                await NSSMusic.needsToSubscribe()
            )
        }
    }
}

extension NSSMusic {
    public static func checkCurrentStatus() -> AuthorizationStatus {
        MusicAuthorization.currentStatus
    }

    public static func requestAuthorization() async -> AuthorizationStatus {
        await MusicAuthorization.request()
    }

    public static func needsToSubscribe() async -> SubscriptionStatus {
        let subsription = await MusicSubscription.subscriptionUpdates.first(where: { $0.canPlayCatalogContent })
        return (subsription == nil, subsription)
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
            Logger.music.info(".getSongArtworkFrom(song:Song) - song?.artwork?.url - song: \"\(song?.id.rawValue ?? "")\"")
        }
        return nil
    }
}

extension NSSMusic {
    @discardableResult
    private func updateAuthorization(_ authorization: AuthorizationStatus, _ needsToSubscribe: SubscriptionStatus) -> Bool {
        self.authorized = authorization == .authorized && !needsToSubscribe.0
        self.needsToSubscribe = needsToSubscribe.0
        return self.authorized
    }

    @discardableResult
    public func checkCurrentAuthorization() async -> Bool {
        let authorization = await NSSMusic.requestAuthorization()
        let needsToSubscribe = await NSSMusic.needsToSubscribe()
        return self.updateAuthorization(authorization, needsToSubscribe)
    }

    @discardableResult
    public func requestAuthorization() async -> Bool {
        self.updateAuthorization(
            await NSSMusic.requestAuthorization(),
            await NSSMusic.needsToSubscribe()
        )
    }

    @discardableResult
    public func requestAuthorization(_ toggle: Binding<Bool>) async -> Bool {
        let authorization = await self.requestAuthorization()
        if authorization {
            return true
        } else {
            toggle.wrappedValue.toggle()
            return false
        }
    }
}

extension NSSMusic {

    public static let player: MPMusicPlayerController = .applicationMusicPlayer
    public static let queue: MPMusicPlayerController = .applicationQueuePlayer
    public static let system: MPMusicPlayerController = .systemMusicPlayer

    public static var nowPlaying: MPMediaItem? {
        return if let item = self.system.nowPlayingItem,
                  item.mediaType == .music {
            item
        } else {
            nil
        }
    }
    public static var nowPlaybackTime: TimeInterval {
        get {
            self.system.currentPlaybackTime
        }
        set {
            self.system.currentPlaybackTime = newValue
        }
    }
    //    public static var currentQueue: MPMusicPlayerControllerQueue

    private static func describe(player: MPMusicPlayerController) -> String {
        var desc = ""
        desc += "Player ................ : \(String(describing: player)) \n"
        desc += "Current Playback Rate . : \(player.currentPlaybackRate) \n"
        desc += "Current Playback Time . : \(player.currentPlaybackTime) \n"
        desc += "Index Of Now Playing .. : \(player.indexOfNowPlayingItem) \n"
        desc += "Is Prepared to play ... : \(player.isPreparedToPlay) \n"
        desc += "Now Playing Item ...... : \(String(describing: player.nowPlayingItem)) \n"
        desc += "Playback State ........ : \(String(describing: player.playbackState)) \n"
        desc += "Repeat Mode ........... : \(String(describing: player.repeatMode)) \n"
        desc += "Shuffle Mode .......... : \(String(describing: player.shuffleMode)) \n"
        return desc + describe(musicItem: player.nowPlayingItem)
    }

    private static func describe(musicItem item: MPMediaItem?) -> String {
        if let item = item {
            var desc = "\n"
            desc += "Item ................ : \(String(describing: item)) \n"
            desc += "albumArtistPersistentID . : \(item.albumArtistPersistentID) \n"
            desc += "albumPersistentID . : \(item.albumPersistentID) \n"
            desc += "___ . : \(item.albumTrackCount) \n"
            desc += "___ . : \(item.albumTrackNumber) \n"
            desc += "artistPersistentID . : \(item.artistPersistentID) \n"
            desc += "___ . : \(item.beatsPerMinute) \n"
            desc += "___ . : \(item.bookmarkTime) \n"
            desc += "composerPersistentID . : \(item.composerPersistentID) \n"
            desc += "___ . : \(item.dateAdded) \n"
            desc += "___ . : \(item.discCount) \n"
            desc += "___ . : \(item.discNumber) \n"
            desc += "genrePersistentID . : \(item.genrePersistentID) \n"
            desc += "___ . : \(item.hasProtectedAsset) \n"
            desc += "isCloudItem . : \(item.isCloudItem) \n"
            desc += "___ . : \(item.isCompilation) \n"
            desc += "isExplicitItem . : \(item.isExplicitItem) \n"
            desc += "___ . : \(item.isPreorder) \n"
            desc += "persistentID . : \(item.persistentID) \n"
            desc += "___ . : \(item.playCount) \n"
            desc += "___ . : \(item.playbackDuration) \n"
            desc += "playbackStoreID . : \(item.playbackStoreID) \n"
            desc += "___ . : \(item.podcastPersistentID) \n"
            desc += "___ . : \(item.rating) \n"
            desc += "___ . : \(item.skipCount) \n"
            desc += "albumArtist . : \(String(describing: item.albumArtist)) \n"
            desc += "albumTitle . : \(String(describing: item.albumTitle)) \n"
            desc += "artist . : \(String(describing: item.artist)) \n"
            desc += "artwork . : \(String(describing: item.artwork)) \n"
            desc += "assetURL . : \(String(describing: item.assetURL)) \n"
            desc += "___ . : \(String(describing: item.comments)) \n"
            desc += "___ . : \(String(describing: item.composer)) \n"
            desc += "___ . : \(String(describing: item.genre)) \n"
            desc += "___ . : \(String(describing: item.lastPlayedDate)) \n"
            desc += "___ . : \(String(describing: item.lyrics)) \n"
            desc += "___ . : \(String(describing: item.mediaType)) \n"
            desc += "___ . : \(String(describing: item.podcastTitle)) \n"
            desc += "___ . : \(String(describing: item.releaseDate)) \n"
            desc += "___ . : \(String(describing: item.mediaType)) \n"
            desc += "___ . : \(String(describing: item.title)) \n"
            desc += "___ . : \(String(describing: item.userGrouping)) \n"
            return desc + describe(artwork: item.artwork)
        }
        return ""
    }

    private static func describe(artwork item: MPMediaItemArtwork?) -> String {
        if let item = item {
            var desc = "\n"
            desc += "Artwork ................ : \(String(describing: item)) \n"
            desc += "bounds . : \(item.bounds) \n"
            desc += "albumPersistentID . : \(String(describing: item.image(at: .init(width: 512, height: 512)))) \n"
            return desc
        }
        return ""
    }

    public static func play() {
        Logger.music.debug("\(NSSMusic.describe(player: player))")
        Logger.music.debug("\(NSSMusic.describe(player: queue))")
        Logger.music.debug("\(NSSMusic.describe(player: system))")
    }

    public static var playbackState: MPMusicPlaybackState {
        self.system.playbackState
    }

    public static var playbackTime: TimeInterval {
        self.system.currentPlaybackTime
    }

    public static var playbackDuration: TimeInterval? {
        self.system.nowPlayingItem?.playbackDuration
    }

}
