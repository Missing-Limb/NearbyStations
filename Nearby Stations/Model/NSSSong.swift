//
//  NSSSong.swift
//  Nearby Stations
//
//  Created by Guillaume Coquard on 17/12/23.
//

import Foundation
import MusicKit
import CloudKit
import MediaPlayer
import OSLog

@Observable
final class NSSSong: NSObject, Identifiable {

    internal enum NSSSongType: Int {
        case system = 0
        case aMusic = 1
    }

    public static var now: NSSSong = .init()

    public var id: String? {
        switch itemType {
        case .system:
            self.mediaItem?.playbackStoreID
        case .aMusic:
            self.musicItem?.id.rawValue ?? self.musicItemID
        }
    }

    internal let itemType: NSSSongType
    internal var mediaItem: MPMediaItem? {
        return if self.itemType == .system {
            NSSMusic.nowPlaying
        } else {
            nil
        }
    }

    internal private(set) var musicItem: Song?
    private var musicItemID: String?
    private var musicItemPlaybackTime: TimeInterval? = 0.0

    public private(set) var saveTime: TimeInterval? = 0

    public var playbackDuration: TimeInterval? {
        switch itemType {
        case .system:
            self.mediaItem!.playbackDuration
        case .aMusic:
            self.musicItem!.duration
        }
    }
    public private(set) var playbackTime: TimeInterval? {
        get {
            return switch itemType {
            case .system:
                NSSMusic.nowPlaybackTime
            case .aMusic:
                self.musicItemPlaybackTime
            }
        }
        set {
            switch itemType {
            case .system: break
            case .aMusic:
                self.musicItemPlaybackTime = newValue
            }
        }
    }
    public private(set) var artwork: UIImage?

    public var title: String? {
        switch itemType {
        case .system:
            self.mediaItem?.title
        case .aMusic:
            self.musicItem?.title
        }
    }
    public var artist: String? {
        switch itemType {
        case .system:
            self.mediaItem?.artist
        case .aMusic:
            self.musicItem?.artistName
        }
    }
    public var album: String? {
        switch itemType {
        case .system:
            self.mediaItem?.albumTitle
        case .aMusic:
            self.musicItem?.albumTitle
        }
    }

    init(from item: MPMediaItem?) {
        self.itemType = .system
        self.musicItem = nil
        super.init()
        self.playbackTime = NSSMusic.nowPlaybackTime
        Task {
            self.artwork = await self.getImage()
        }
    }

    override private convenience init() {
        self.init(from: NSSMusic.nowPlaying)
    }

    init(from item: Song?, at playbackTime: TimeInterval? = 0, savedAt time: TimeInterval? = -1) {
        self.itemType = .aMusic
        self.musicItemID = item?.id.rawValue
        self.musicItem = item
        super.init()
        self.playbackTime = playbackTime ?? 0
        self.saveTime = time
        Task {
            self.artwork = await self.getImage()
        }
    }

    init(from item: String, at playbackTime: TimeInterval? = 0, savedAt time: TimeInterval? = -1) {
        self.itemType = .aMusic
        self.musicItemID = item
        super.init()
        self.playbackTime = playbackTime
        self.saveTime = time
        Task {
            let song = await NSSMusic.getSongFrom(string: item)
            self.musicItem = song
            Task {
                self.artwork = await self.getImage()
            }
        }
    }

    convenience init(from record: CKRecord) {
        let id = (record["songIdentifier"] as! String)
        let playbackTime = (record["playbackTime"] as? TimeInterval) ?? 0
        let saveTime = (record["playbackTime"] as? TimeInterval) ?? -1
        self.init(from: id, at: playbackTime, savedAt: saveTime)
    }

    private func getImage() async -> UIImage? {
        switch itemType {
        case .system:
            return self.mediaItem?.artwork?.image(at: .init(width: 512, height: 512))
        case .aMusic:
            if let data = await NSSMusic.getSongArtworkFrom(song: self.musicItem) {
                return UIImage(data: data)
            }
        }
        return nil
    }

    @discardableResult
    public func updateSong() async -> Bool {
        switch itemType {
        case .system: break
        case .aMusic:
            if self.musicItem == nil && self.id != nil {
                self.musicItem = await NSSMusic.getSongFrom(string: self.id!)
            }
        }
        return (self.mediaItem != nil || self.musicItem != nil)
    }

    @discardableResult
    public func updateImage() async -> Bool {
        self.artwork = await self.getImage()
        return self.artwork != nil
    }

    @discardableResult
    public func update() async -> Bool {
        let songUpdated: Bool = await self.updateSong()
        let artworkUpdated: Bool = await self.updateImage()
        return songUpdated && artworkUpdated
    }

    public func setPlaybackTime(to time: TimeInterval) {
        self.playbackTime = time
    }

}
