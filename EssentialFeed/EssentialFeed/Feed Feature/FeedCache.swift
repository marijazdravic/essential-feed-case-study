//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Marija Zdravic on 24.11.2025..
//

import Foundation

public protocol FeedCache {
    typealias SaveResult = Result<Void, Error>
    
    func save(_ feed: [FeedImage], completion: @escaping (SaveResult) -> Void)
}
