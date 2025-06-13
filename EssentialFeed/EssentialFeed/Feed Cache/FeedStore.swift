//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Marija Zdravic on 05.06.2025..
//

import Foundation

public enum RetrieveCachedFeedResult {
    case empty
    case found(feed: [LocalFeedImage], timestamp: Date)
    case failure(Error)
}

public protocol FeedStore {
    typealias DeleteCompletion = (Error?) -> Void
    typealias InsertCompletion = (Error?) -> Void
    typealias RetrievalCompletion = (RetrieveCachedFeedResult) -> Void
    
    func deleteCashedFeed(completion: @escaping DeleteCompletion)
    func insert(_ feed: [LocalFeedImage], timestamp: Date, completion: @escaping InsertCompletion)
    func retrieve(completion: @escaping RetrievalCompletion)
}
