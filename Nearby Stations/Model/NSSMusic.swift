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
final class NSSMusic: NSObject, ObservableObject {

    public static let shared: NSSMusic = .init(delegate: .debug)

    public static func getCurrentSongId() -> String? {
        return SystemMusicPlayer.shared.queue.currentEntry?.id ?? nil
    }

    public static func getSongFrom(musicItemID id: MusicItemID) async throws -> Song? {
        try await MusicCatalogResourceRequest<Song>(
            matching: \.id,
            equalTo: id
        ).response().items.first ?? nil
    }

    public static func getSongFrom(string id: String) async throws -> Song? {
        try await MusicCatalogResourceRequest<Song>(
            matching: \.id,
            equalTo: MusicItemID(rawValue: id)
        ).response().items.first ?? nil
    }

    public static func request() async -> Bool {
        await MusicAuthorization.request() == .authorized
    }

    public static func isAbleToStream() async -> Bool {
        await MusicSubscription.subscriptionUpdates.first { $0.canPlayCatalogContent } != nil
    }

    public static func getSongArtworkFrom(song: Song?) async -> Data? {
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
                print(error.localizedDescription)
            }
        }
        return nil
    }

    public private(set) var authorized: Bool = false {
        willSet {
            self.delegate?.manager(self, willSetAuthorized: newValue)
        }
        didSet {
            self.delegate?.manager(self, didSetAuthorized: oldValue)
        }
    }

    public var delegate: NSSMusicManagerDelegate?

    /// No private set because i have to give away control to the system through musicSubscriptionOffer model sheet
    public var needsToSubscribe: Bool = true {
        willSet {
            self.delegate?.manager(self, willSetNeedsToSubscribe: newValue)
        }
        didSet {
            self.delegate?.manager(self, didSetNeedsToSubscribe: oldValue)
        }
    }

    init(
        delegate: NSSMusicManagerDelegate? = nil
    ) {
        Logger.music.debug("willInitNSSMusic")
        self.delegate = delegate
        super.init()
        self.delegate?.manager(self, didInit: self)
    }

    internal func updateAuthorization(_ value: Bool) {
        self.authorized = value
        Logger.music.debug(".updateAuthorization - authorized - set: \(self.authorized)")
    }

    public func requestAuthorization() async {
        self.updateAuthorization(await NSSMusic.request())
        Logger.music.debug(".requestAuthorization")
    }
}
