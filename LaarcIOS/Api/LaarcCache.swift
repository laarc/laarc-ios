//
//  LaarcCache.swift
//  LaarcIOS
//
//  Created by Emily Kolar on 2/8/19.
//  Copyright © 2019 Emily Kolar. All rights reserved.
//

import Foundation
import Cache

class LaarcCache {
    static let shared = LaarcCache()
    
    private let _diskConfig = DiskConfig(name: "LaarcCache")
    private let _memoryConfig = MemoryConfig(expiry: Expiry.never, countLimit: 0, totalCostLimit: 0)
    private let _kHistory = "HISTORY"

    private var _storage: Storage<HistoryItem>?
    private var _idsStorage: Storage<[String]>?

    private init() {
        _storage = try? Storage(diskConfig: _diskConfig, memoryConfig: _memoryConfig, transformer: TransformerFactory.forCodable(ofType: HistoryItem.self))

        _idsStorage = try? Storage(diskConfig: _diskConfig, memoryConfig: _memoryConfig, transformer: TransformerFactory.forCodable(ofType: [String].self))
    }

    public func pushToHistory(_ item: HistoryItem) {
        let itemStorage = _storage?.transformCodable(ofType: HistoryItem.self)
        let strStorage = _idsStorage?.transformCodable(ofType: [String].self)

        if let history = try? _idsStorage?.object(forKey: _kHistory), var h = history {
            h.forEach({ print($0) })
            h.append(String(item.id))
            try? strStorage?.setObject(h, forKey: _kHistory)
        } else {
            var history = [String]()
            history.append(String(item.id))
            try? strStorage?.setObject(history, forKey: _kHistory)
        }

        try? itemStorage?.setObject(item, forKey: String(item.id))
    }
    
    public func removeFromHistory(_ item: HistoryItem) {
        let itemStorage = _storage?.transformCodable(ofType: HistoryItem.self)
        try? itemStorage?.removeObject(forKey: String(item.id))
    }
    
    public func removeAllFromHistory() {
        let itemStorage = _storage?.transformCodable(ofType: HistoryItem.self)
        try? itemStorage?.removeAll()
    }
    
    public func getHistory(_ completion: @escaping ([HistoryItem]) -> Void) {
        var items = [HistoryItem]()
        let itemStorage = _storage?.transformCodable(ofType: HistoryItem.self)
        let strStorage = _idsStorage?.transformCodable(ofType: [String].self)
        if let history = try? strStorage?.object(forKey: _kHistory),
            let h = history {
            var retrieved = 0

            h.forEach({ id in
                if let storedItem = try? itemStorage?.object(forKey: id),
                    let si = storedItem {
                    items.append(si)
                    retrieved += 1
                } else {
                    retrieved += 1
                }

                if retrieved == h.count {
                    completion(items)
                }
            })
        } else {
            completion(items)
        }
    }
}
