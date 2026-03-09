//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Marija Zdravic on 24.11.2025..
//

import Foundation

public protocol FeedCache {
    func save(_ feed: [FeedImage]) throws
}
