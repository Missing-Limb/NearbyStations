//
//  NSSMusic+MediaPlayer.swift
//  Nearby Stations
//
//  Created by Guillaume Coquard on 18/12/23.
//

import Foundation
import MediaPlayer
import OSLog

extension NSSMusic {

    public static let sPlayer: MPMusicPlayerController = .applicationMusicPlayer
    public static let sQueue: MPMusicPlayerController = .applicationQueuePlayer
    public static let sSystem: MPMusicPlayerController = .systemMusicPlayer

    public static var nowPlayingSystem: MPMediaItem? {
        return if let item = self.sSystem.nowPlayingItem,
                  item.mediaType == .music {
            item
        } else {
            nil
        }
    }

    public static var nowPlaybackTimeSystem: TimeInterval {
        get {
            self.sSystem.currentPlaybackTime
        }
        set {
            self.sSystem.currentPlaybackTime = newValue
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
            desc += "albumPersistentID . : \(item.albumPersistentID) \n"
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

    public static var playbackStateSystem: MPMusicPlaybackState {
        self.sSystem.playbackState
    }

    public static var playbackTimeSystem: TimeInterval {
        self.sSystem.currentPlaybackTime
    }

    public static var playbackDurationSystem: TimeInterval? {
        self.sSystem.nowPlayingItem?.playbackDuration
    }
}
