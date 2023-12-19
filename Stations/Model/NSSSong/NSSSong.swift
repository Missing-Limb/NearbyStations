//
//  NSSSong.swift
//  Nearby Stations
//
//  Created by Guillaume Coquard on 17/12/23.
//

import Foundation
import MusicKit
import CloudKit
import OSLog
import SwiftUI
//
// protocol NSSSong: AnyObject, Identifiable, PlayableMusicItem {
//    var id: MusicItemID { get }
//    var identifier: String? { get }
//    var title: String? { get }
//    var artist: String? { get }
//    var album: String? { get }
//    var artwork: UIImage? { get }
//    var song: Song? { get }
//    var playParameters: PlayParameters? { get set }
//    var playbackTime: TimeInterval? { get set }
//    var playbackDuration: TimeInterval? { get }
//    var saveTime: TimeInterval? { get }
//    func updateSong() async -> Bool
//    func updateImage() async -> Bool
//    func update() async -> Bool
//    func setPlaybackTime(to time: TimeInterval)
// }

struct NSSSong {
    let id: String
    var playbackTime: TimeInterval = 0
    var saveTime: TimeInterval = 0

    init(from record: CKRecord) {
        self.id = (record["songIdentifier"] as? String) ?? ""
        self.playbackTime = (record["playbackTime"] as? TimeInterval) ?? 0
        self.saveTime = (record["playbackTime"] as? TimeInterval) ?? 0
    }

    init(id: String) {
        self.id = id
        self.playbackTime = 0
    }
}
