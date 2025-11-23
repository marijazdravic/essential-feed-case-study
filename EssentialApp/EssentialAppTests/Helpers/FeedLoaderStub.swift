//
//  FeedLoaderStub.swift
//  EssentialAppTests
//
//  Created by Marija Zdravic on 24.11.2025..
//

import Foundation
import EssentialFeed

class FeedLoaderStub: FeedLoader {
    private let result: FeedLoader.Result
    
    init(result: FeedLoader.Result) {
        self.result = result
    }
    
    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        completion(result)
    }
}
