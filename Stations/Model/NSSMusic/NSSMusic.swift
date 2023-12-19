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
}
