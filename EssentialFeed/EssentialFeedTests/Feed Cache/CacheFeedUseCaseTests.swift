//
//  CacheFeedUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Marija Zdravic on 03.06.2025..
//

import Foundation
import XCTest
import EssentialFeed

class FeedStore {
    var deleteCashedFeedCallCount = 0
    
    func deleteCashedFeed() {
        deleteCashedFeedCallCount += 1
    }
}

class LocalFeedLoader {
    private let store: FeedStore

    init(store: FeedStore) {
        self.store = store
    }
    
    func save(_ items: [FeedItem]) {
        store.deleteCashedFeed()
    }
}

class CacheFeedUseCaseTests: XCTestCase {
    
    func test_init_doesNotDeleteCacheUponCreation() {
        let store = FeedStore()
        _ = LocalFeedLoader(store: store)
        
        XCTAssertEqual(store.deleteCashedFeedCallCount, 0)
    }
    
    func test_save_requestsCacheDeletion() {
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store)
        
        let items = [uniqueItem(), uniqueItem()]
        sut.save(items)
        
        XCTAssertEqual(store.deleteCashedFeedCallCount, 1)
    }
    
// MARK: - Helpers
    
    private func uniqueItem() -> FeedItem {
        return FeedItem(id: UUID(), description: "any", location: "any", imageURL: anyURL())
    }
    
    private func anyURL() -> URL {
        return URL(string: "http://any-url.com")!
    }
}
