//
//  LocalFeedLoader.swift
//  EssentialFeed
//
//  Created by Marija Zdravic on 04.06.2025..
//

import Foundation

public final class LocalFeedLoader {
    private let store: FeedStore
    private let currentDate: () -> Date
    
    public typealias SaveResult = Error?
    
    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    public func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void) {
        store.deleteCashedFeed { [weak self] error in
            guard let self = self else { return }
            
            if let cacheDeletionError = error {
                completion(cacheDeletionError)
            } else {
                self.cache(feed, with: completion)
            }
        }
    }
    
    func cache(_ items: [FeedImage], with completion: @escaping (SaveResult) -> Void) {
        store
            .insert(items.toLocal(), timestamp: self.currentDate()) { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }
    
    public func load(completion: @escaping (Error?) -> Void) {
        store.retrieve(completion: completion)
    }
}

private extension Array where Element == FeedImage {
    func toLocal() -> [LocalFeedImage] {
        return map {
            LocalFeedImage(
                id: $0.id,
                description: $0.description,
                location: $0.location,
                imageURL: $0.url
            )
        }
    }
}
