//
//  NSSMusic+Player.swift
//  Nearby Stations
//
//  Created by Guillaume Coquard on 18/12/23.
//

import Foundation
import MusicKit
import _MusicKit_SwiftUI
import OSLog

extension NSSMusic {

    public static let player: SystemMusicPlayer = .shared
    public static let appli: ApplicationMusicPlayer = .shared

    public var nowPlayingEntry: MusicPlayer.Queue.Entry? {
        NSSMusic.player.queue.currentEntry
    }
    public var nowPlaying: MusicPlayer.Queue.Entry.Item? {
        NSSMusic.player.queue.currentEntry?.item
    }
    public func nowPlayingSong() async -> Song? {
        if let entry = self.nowPlayingEntry,
           let item = entry.item {
            return if let song = await NSSMusic.getSongFrom(musicItemID: item.id) {
                song
            } else {
                nil
            }
        }
        return nil
    }

    public var nowPlaybackTime: TimeInterval {
        get {
            NSSMusic.player.playbackTime
        }
        set {
            NSSMusic.player.playbackTime = newValue
        }
    }

    public var currentQueue: MusicPlayer.Queue {
        NSSMusic.player.queue
    }

    public var isPreparedToPlay: Bool {
        NSSMusic.player.isPreparedToPlay
    }

    public var state: MusicPlayer.State {
        NSSMusic.player.state
    }

    public func play() async {
        do {
            try await NSSMusic.player.play()
        } catch {
            Logger.music.error("\(error.localizedDescription)")
        }
    }

    public func play(
        song: Song,
        at playbackTime: TimeInterval,
        savedAt time: TimeInterval
    ) async {
        var updatedPlaybackTime: TimeInterval = 0
        if time > 0 {
            let now = Date().timeIntervalSince1970
            let timeDiff = now - time
            let updatedPlaybackTime = playbackTime + timeDiff
        } else {
            updatedPlaybackTime = playbackTime
        }
        if updatedPlaybackTime < (song.duration ?? .infinity) {
            do {
                try await NSSMusic.player.queue.insert(
                    MusicPlayer.Queue.Entry(song),
                    position: .afterCurrentEntry
                )
                try await NSSMusic.player.skipToNextEntry()
                NSSMusic.player.playbackTime = updatedPlaybackTime
                try await NSSMusic.player.play()
            } catch {
                Logger.music.error("\(error.localizedDescription)")
            }
        }
    }

    public func pause() {
        NSSMusic.player.pause()
    }

    public func next() async {
        do {
            try await NSSMusic.player.skipToNextEntry()
        } catch {
            Logger.music.error("\(error.localizedDescription)")
        }
    }

    public func previous() async {
        do {
            try await NSSMusic.player.skipToPreviousEntry()
        } catch {
            Logger.music.error("\(error.localizedDescription)")
        }
    }

    public func addToQueue(songs: Song?...) async {
        let entries = songs.filter({$0 != nil}).compactMap({ MusicPlayer.Queue.Entry($0!) })
        do {
            try await NSSMusic.player.queue.insert(entries, position: .afterCurrentEntry)
        } catch {
            Logger.music.error("\(error.localizedDescription)")
        }
    }

    private static func describe(entry item: MusicPlayer.Queue.Entry?) -> String {
        if let item = item {
            var desc = "\n"
            desc += "Item ................ : \(String(describing: item)) \n"
            desc += "Item.Item ........... : \(String(describing: item.item)) \n"
            desc += "Item.TransientItem .. : \(String(describing: item.transientItem)) \n"
            desc += "isTransient ......... : \(item.isTransient) \n"
            desc += "Title ............... : \(item.title) \n"
            desc += "Subtitle ............ : \(String(describing: item.subtitle)) \n"
            desc += "Start Time .......... : \(String(describing: item.startTime)) \n"
            desc += "End Time ............ : \(String(describing: item.endTime)) \n"
            desc += "Artwork ............. : \(String(describing: item.artwork)) \n"
            return desc + describe(entryItem: item.item) + describe(playableItem: item.transientItem)
        }
        return ""
    }

    private static func describe(entryItem item: MusicPlayer.Queue.Entry.Item?) -> String {
        if let item = item {
            var desc = "\n"
            desc += "Item ............. : \(String(describing: item)) \n"
            desc += "ID ............... : \(String(describing: item.id)) \n"
            desc += "PlayParameters ... : \(String(describing: item.playParameters)) \n"
            return desc
        }
        return ""
    }

    private static func describe(playableItem item: PlayableMusicItem?) -> String {
        if let item = item {
            var desc = "\n"
            desc += "Playable Item ....... : \(String(describing: item)) \n"
            desc += "Id ................ : \(item.id) \n"
            desc += "PlayParameters .... : \(String(describing: item.playParameters)) \n"
            return desc
        }
        return ""
    }

}
