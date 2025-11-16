//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Marija Zdravic on 16.11.2025..
//

import Foundation

public protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>
    
    func retrieve(dataForURL url: URL, completion: @escaping (Result) -> Void)
}
