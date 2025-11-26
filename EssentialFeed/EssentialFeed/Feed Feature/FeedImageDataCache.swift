//
//  FeedImageCache.swift
//  EssentialFeed
//
//  Created by Marija Zdravic on 26.11.2025..
//

import Foundation

public protocol FeedImageDataCache {
    typealias SaveResult = Result<Void, Swift.Error>
    
    func save(_ data: Data, for url: URL, completion: @escaping (SaveResult) -> Void)
}

