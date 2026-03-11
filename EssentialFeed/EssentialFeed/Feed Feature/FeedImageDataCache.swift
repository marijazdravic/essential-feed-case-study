//
//  FeedImageCache.swift
//  EssentialFeed
//
//  Created by Marija Zdravic on 26.11.2025..
//

import Foundation

public protocol FeedImageDataCache {
    func save(_ data: Data, for url: URL) throws
}

