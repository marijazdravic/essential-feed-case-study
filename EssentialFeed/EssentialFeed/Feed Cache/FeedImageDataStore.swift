//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Marija Zdravic on 16.11.2025..
//

import Foundation

public protocol FeedImageDataStore {
    func insert(_ data: Data, for url: URL) throws
    func retrieve(dataForURL url: URL) throws -> Data?
}
