//
//  LocalFeedLoader.swift
//  EssentialFeed
//
//  Created by Marija Zdravic on 04.06.2025..
//

import Foundation

public protocol FeedStore {
    typealias DeleteCompletion = (Error?) -> Void
    typealias InsertCompletion = (Error?) -> Void
    
    func deleteCashedFeed(completion: @escaping DeleteCompletion)
    func insertItems(_ items: [FeedItem], timestamp: Date, completion: @escaping InsertCompletion)
}

public final class LocalFeedLoader {
    private let store: FeedStore
    private let currentDate: () -> Date
    
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    public func save(_ items: [FeedItem], completion: @escaping (Error?) -> Void) {
        store.deleteCashedFeed { [weak self] error in
            guard let self = self else { return }
            
            if let cacheDeletionError = error {
                completion(cacheDeletionError)
            } else {
                self.cache(items, with: completion)
            }
        }
    }
    
    func cache(_ items: [FeedItem], with completion: @escaping (Error?) -> Void) {
        store.insertItems(items, timestamp: self.currentDate()) { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }
}
