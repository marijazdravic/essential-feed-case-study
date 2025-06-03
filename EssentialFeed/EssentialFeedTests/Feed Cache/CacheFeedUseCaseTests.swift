//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Marija Zdravic on 03.06.2025..
//

import Foundation
import XCTest

class FeedStore {
    var deleteCashedFeedCallCount = 0
}

class LocalFeedLoader {
    init(store: FeedStore) {
    }
}

class CacheFeedUseCaseTests: XCTestCase {
    
    func test_init_doesNotDeleteCacheUponCreation() {
        let store = FeedStore()
        _ = LocalFeedLoader(store: store)
        
        XCTAssertEqual(store.deleteCashedFeedCallCount, 0)
    }
}
