//
//  OrderedSet.swift
//  StationSlider
//
//  Created by Guillaume Coquard on 13/12/23.
//

import Foundation
import Collections
import OrderedCollections

extension Deque<NSSStation> {
    func contains(_ element: Self.Element.ID?) -> Bool {
        self.contains(where: { $0.id == element })
    }

    var firstDifferent: Self.Element? {
        self.first(where: { $0 != NSSStation.default })
    }

    var open: Self.Element? {
        self.first(where: { $0.open })
    }

    func open(differentFrom element: Self.Element) -> Self.Element? {
        self.first(where: { $0.open && $0 != element })
    }
}

extension Array<NSSStation> {
    func contains(_ element: Self.Element.ID?) -> Bool {
        self.contains(where: { $0.id == element })
    }

    var open: Self.Element? {
        self.first(where: { $0.open })
    }

    func open(differentFrom element: Self.Element) -> Self.Element? {
        self.first(where: { $0.open && $0 != element })
    }
}

extension Set<NSSStation> {
    func contains(_ element: Self.Element.ID?) -> Bool {
        self.contains(where: { $0.id == element })
    }

    var open: Self.Element? {
        self.first(where: { $0.open })
    }

    func open(differentFrom element: Self.Element) -> Self.Element? {
        self.first(where: { $0.open && $0 != element })
    }
}

extension Dictionary<UUID, NSSStation> {
    func contains(_ elementID: Self.Key?) throws -> Bool {
        self.contains(where: { (key: Self.Key, _: Self.Value) in key == elementID })
    }

    var open: Self.Value? {
        self.first(where: { (_, element: Self.Value) in element.open })?.value
    }

    func open(differentFrom comparableElement: Self.Value) -> Self.Value? {
        self.first(where: { (_, element: Self.Value) in element.open && element != comparableElement })?.value
    }
}

extension OrderedSet<NSSStation> {
    func contains(_ element: Self.Element.ID?) -> Bool {
        self.contains(where: { $0.id == element })
    }

    var open: Self.Element? {
        self.first(where: { $0.open })
    }

    func open(differentFrom element: Self.Element) -> Self.Element? {
        self.first(where: { $0.open && $0 != element })
    }
}
