//
//  NSSCloud.swift
//  Nearby Stations
//
//  Created by Guillaume Coquard on 17/12/23.
//

import Foundation
import CloudKit
import Collections
import OSLog
import Combine

@Observable
final class NSSCloud: NSObject {

    static public let shared: NSSCloud = .init()

    static private let recordTypeName: String = "Station"
    static private let recordTypeSong: String = "StationSong"
    static private let recordTypeListeners: String = "StationListeners"
    static private let recordTypeLocation: String = "StationLocation"

    static private var ckRecords: Set<CKRecord> = []
    static private let ckContainer: CKContainer = CKContainer.default()
    static private var ckDatabase: CKDatabase {
        self.ckContainer.publicCloudDatabase
    }

    private var myRecordIDName: CKRecord.ID?
    private var myRecordIDSong: CKRecord.ID?
    private var myRecordIDListeners: CKRecord.ID?
    private var myRecordIDLocation: CKRecord.ID?

    public var stations: Set<NSSStation> = [] {
        didSet {
            NotificationCenter.default.post(name: .stationsRetrieved, object: nil)
        }
    }

    public func createOrUpdateName() async -> Bool {
        let station: NSSStation = .default
        let record: CKRecord = CKRecord(recordType: NSSCloud.recordTypeName)
        record.setValue(station.id, forKey: "identifier")
        record.setValue(station.name, forKey: "name")
        do {
            if let id = self.myRecordIDName {
                self.myRecordIDName = record.recordID
                let (saveResults, _) = try await NSSCloud.ckDatabase.modifyRecords(saving: [record], deleting: [id])
                for (_, result) in saveResults {
                    return (try result.get()).isKind(of: CKRecord.self)
                }
            } else {
                self.myRecordIDName = record.recordID
                let record = try await NSSCloud.ckDatabase.save(record)
                return record.isKind(of: CKRecord.self)
            }
        } catch {
            Logger.cloud.error("\(error.localizedDescription)")
        }
        Logger.cloud.warning("Name for .default not created or updated.")
        return false
    }
    public func createOrUpdateSong() async -> Bool {
        let station: NSSStation = .default
        let record: CKRecord = CKRecord(recordType: NSSCloud.recordTypeSong)
        record.setValue(station.id, forKey: "identifier")
        record.setValue(station.song!.id, forKey: "songIdentifier")
        record.setValue(station.playbackTime, forKey: "playbackTime")
        //        record.setValue(NSSMusic.currentQueue, forKey: "queue")
        record.setValue(Date().timeIntervalSince1970, forKey: "saveTime")
        do {
            if let id = self.myRecordIDSong {
                self.myRecordIDSong = record.recordID
                let (saveResults, _) = try await NSSCloud.ckDatabase.modifyRecords(saving: [record], deleting: [id])
                for (_, result) in saveResults {
                    return (try result.get()).isKind(of: CKRecord.self)
                }
            } else {
                self.myRecordIDSong = record.recordID
                let record = try await NSSCloud.ckDatabase.save(record)
                return record.isKind(of: CKRecord.self)
            }
        } catch {
            Logger.cloud.error("\(error.localizedDescription)")
        }
        Logger.cloud.warning("Song for .default not created or updated.")
        return false
    }
    public func createOrUpdateLocation() async -> Bool {
        let station: NSSStation = .default
        let record: CKRecord = CKRecord(recordType: NSSCloud.recordTypeLocation)
        record.setValue(station.id, forKey: "identifier")
        record.setValue(station.location, forKey: "location")
        do {
            if let id = self.myRecordIDLocation {
                self.myRecordIDLocation = record.recordID
                let (saveResults, _) = try await NSSCloud.ckDatabase.modifyRecords(saving: [record], deleting: [id])
                for (_, result) in saveResults {
                    return (try result.get()).isKind(of: CKRecord.self)
                }
            } else {
                self.myRecordIDLocation = record.recordID
                let record = try await NSSCloud.ckDatabase.save(record)
                return record.isKind(of: CKRecord.self)
            }
        } catch {
            Logger.cloud.error("\(error.localizedDescription)")
        }
        Logger.cloud.warning("Location for .default not created or updated.")
        return false
    }
    public func createListeners() async -> Bool {
        let station: NSSStation = .default
        let record: CKRecord = CKRecord(recordType: NSSCloud.recordTypeListeners)
        record.setValue(station.id, forKey: "identifier")
        record.setValue(station.listeners, forKey: "listeners")
        do {
            if let id = self.myRecordIDListeners {
                self.myRecordIDListeners = record.recordID
                let (saveResults, _) = try await NSSCloud.ckDatabase.modifyRecords(saving: [record], deleting: [id])
                for (_, result) in saveResults {
                    return (try result.get()).isKind(of: CKRecord.self)
                }
            } else {
                self.myRecordIDListeners = record.recordID
                let record = try await NSSCloud.ckDatabase.save(record)
                return record.isKind(of: CKRecord.self)
            }
        } catch {
            Logger.cloud.error("\(error.localizedDescription)")
        }
        Logger.cloud.warning("Listeners for .default not created or updated.")
        return false
    }
    public func createMyStation() async -> Bool {
        do {
            return try await withThrowingTaskGroup(of: Bool.self) { group in
                group.addTask { await self.createOrUpdateName() }
                group.addTask { await self.createOrUpdateSong() }
                group.addTask { await self.createOrUpdateLocation() }
                group.addTask { await self.createListeners() }
                var results: Bool = true
                for try await result in group { results = results && result }
                return results
            }
        } catch {
            Logger.cloud.error("\(error.localizedDescription)")
        }
        Logger.cloud.warning(".default not created or updated.")
        return false
    }
    public func deleteMyStation() async -> Bool {
        do {
            let IDs: [CKRecord.ID]? = ([
                self.myRecordIDSong,
                self.myRecordIDLocation,
                self.myRecordIDListeners
            ].filter { $0 != nil }) as? [CKRecord.ID]
            if IDs != nil {
                let (_, deleteResults) = try await NSSCloud.ckDatabase.modifyRecords(
                    saving: [],
                    deleting: IDs!
                )
                return deleteResults.count == IDs!.count
            }
        } catch {
            Logger.cloud.error("\(error.localizedDescription)")
        }
        Logger.cloud.warning(".default not deleted in song or location or listeners.")
        return false
    }

    public static func getStationSongBy(id: String) async -> NSSSong? {
        var record: CKRecord?
        let predicate = NSPredicate(format: "identifier == %@", id)
        let query = CKQuery(recordType: NSSCloud.recordTypeSong, predicate: predicate)
        do {
            let (matchedResults, _) =
                try await ckDatabase.records(
                    matching: query,
                    desiredKeys: [
                        "identifier",
                        "songIdentifier",
                        "playbackTime",
                        "saveTime"
                    ],
                    resultsLimit: 1
                )
            for (_, result) in matchedResults where record == nil {
                return NSSSong(from: (try result.get()))
            }
        } catch {
            Logger.cloud.error("\(error.localizedDescription)")
        }
        Logger.cloud.warning("Song not retrieved for <\(id)>")
        return nil
    }
    public static func getStationSongBy(id: UUID) async -> NSSSong? {
        await NSSCloud.getStationSongBy(id: id.uuidString)
    }
    public static func getStationNameBy(id: String) async -> String? {
        let predicate = NSPredicate(format: "identifier == %@", id)
        let query = CKQuery(recordType: NSSCloud.recordTypeName, predicate: predicate)
        do {
            let (matchedResults, _) =
                try await ckDatabase.records(
                    matching: query,
                    desiredKeys: ["name"],
                    resultsLimit: 1
                )
            for (_, result) in matchedResults {
                let record = try result.get()
                return record.value(forKey: "name") as? String
            }
        } catch {
            Logger.cloud.error("\(error.localizedDescription)")
        }
        Logger.cloud.warning("Name not retrieved for <\(id)>")
        return nil
    }
    public static func getStationNameBy(id: UUID) async -> String? {
        await NSSCloud.getStationNameBy(id: id.uuidString)
    }
    public static func getStationListenersBy(id: String) async -> Int? {
        let predicate = NSPredicate(format: "identifier == %@", id)
        let query = CKQuery(recordType: NSSCloud.recordTypeListeners, predicate: predicate)
        do {
            let (matchedResults, _) =
                try await ckDatabase.records(
                    matching: query,
                    desiredKeys: ["listeners"],
                    resultsLimit: 1
                )
            for (_, result) in matchedResults {
                return try result.get().value(forKey: "listeners") as? Int
            }
        } catch {
            Logger.cloud.error("\(error.localizedDescription)")
        }
        Logger.cloud.warning("Listeners not retrieved for <\(id)>")
        return nil
    }
    public static func getStationListenersBy(id: UUID) async -> Int? {
        return await self.getStationListenersBy(id: id.uuidString)
    }
    public static func getClosestStations(
        within range: Int = 10000,
        resultsLimit limit: Int = 1000,
        count: Int = 10
    ) async -> Set<NSSStation>? {
        let predicate = NSPredicate(
            format: "location.distanceToLocation:fromLocation:(location, %@) < %f",
            NSSStation.default.location!,
            range
        )
        let query = CKQuery(recordType: NSSCloud.recordTypeLocation, predicate: predicate)
        do {
            let (matchedResults, _) = try await NSSCloud.ckDatabase.records(
                matching: query,
                desiredKeys: [ "identifier", "location" ],
                resultsLimit: Int(limit)
            )

            if let location = NSSStation.default.location {
                let records: [CKRecord] = try matchedResults.compactMap { try $0.1.get() }
                return try await withThrowingTaskGroup(of: NSSStation.self) { group in
                    var set: Set<NSSStation> = []
                    records
                        .sorted(relativeTo: location)
                        .prefix(upTo: 10)
                        .forEach { station in group.addTask { await NSSStation(from: station) } }
                    for try await task in group { set.insert(task) }
                    return set

                }
            }
        } catch {
            Logger.cloud.error("\(error.localizedDescription)")
        }
        Logger.cloud.warning("Closest Stations not retrieved.")
        return nil
    }
    public static func getStationsSongBy(ids: any Sequence<String>) async -> [(String, NSSSong)] {
        let ids = Array(ids)
        let predicate: NSPredicate = NSPredicate(format: "identifier IN %@", ids)
        let query = CKQuery(recordType: NSSCloud.recordTypeSong, predicate: predicate)
        do {
            let (matchedResults, _) = try await ckDatabase.records(
                matching: query,
                desiredKeys: [ "identifier", "songIdentifier", "playbackTime", "saveTime" ],
                resultsLimit: ids.count
            )
            let records: [CKRecord] = try matchedResults.map { try $0.1.get() }
            return records.map { (($0["identifier"] as! String), NSSSong(from: $0)) }
        } catch {
            Logger.cloud.error("\(error.localizedDescription)")
        }
        Logger.cloud.warning("Song list not retrieved for \(String(describing: ids)).")
        return []
    }
    public static func getStationsSongBy(stations: any Sequence<NSSStation>) async -> [(String, NSSSong)] {
        await self.getStationsSongBy(ids: Array(stations).map { $0.id.uuidString })
    }
    public static func getStationsNameBy(ids: any Sequence<String>) async -> [(String, String)] {
        let ids = Array(ids)
        let predicate: NSPredicate = NSPredicate(format: "identifier IN %@", ids)
        let query = CKQuery(recordType: NSSCloud.recordTypeName, predicate: predicate)
        do {
            let (matchedResults, _) = try await ckDatabase.records(
                matching: query,
                desiredKeys: [ "identifier", "name" ],
                resultsLimit: ids.count
            )
            let records: [CKRecord] = try matchedResults.map { try $0.1.get() }
            return records.map { (($0["identifier"] as! String), ($0["name"] as! String)) }
        } catch {
            Logger.cloud.error("\(error.localizedDescription)")
        }
        Logger.cloud.warning("Name list not retrieved for \(String(describing: ids)).")
        return []
    }
    public static func getStationsNameBy(stations: any Sequence<NSSStation>) async -> [(String, String)] {
        await self.getStationsNameBy(ids: Array(stations).map { $0.id.uuidString })
    }
    public static func getStationsListenersBy(ids: any Sequence<String>) async -> [(String, Int)] {
        let ids = Array(ids)
        let predicate: NSPredicate = NSPredicate(format: "identifier IN %@", ids)
        let query = CKQuery(recordType: NSSCloud.recordTypeListeners, predicate: predicate)
        do {
            let (matchedResults, _) = try await ckDatabase.records(
                matching: query,
                desiredKeys: [ "identifier", "listeners" ],
                resultsLimit: ids.count
            )
            let records: [CKRecord] = try matchedResults.map { try $0.1.get() }
            return records.map { (($0["identifier"] as! String), ($0["listeners"] as! Int)) }
        } catch {
            Logger.cloud.error("\(error.localizedDescription)")
        }
        Logger.cloud.warning("Name list not retrieved for \(String(describing: ids)).")
        return []
    }
    public static func getStationsListenersBy(stations: any Sequence<NSSStation>) async -> [(String, Int)] {
        await self.getStationsListenersBy(ids: Array(stations).map { $0.id.uuidString })
    }
    public static func getMyListeners() async -> Int? {
        let id: NSSStation.ID = NSSStation.default.id
        return await NSSCloud.getStationListenersBy(id: id)
    }

    override private init() {
        super.init()
    }

}
