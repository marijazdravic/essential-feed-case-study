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
    typealias DeleteCompletion = (Error?) -> Void
    var deleteCashedFeedCallCount = 0
    var insertCallCount = 0
    
    private var deleteCompletions = [DeleteCompletion]()
    
    func deleteCashedFeed(completion: @escaping DeleteCompletion) {
        deleteCashedFeedCallCount += 1
        deleteCompletions.append(completion)
    }
    
    func completeDeletion(with error: Error, at index: Int = 0) {
        deleteCompletions[index](error)
    }
    
    func completeDeletionSeccesfully(at index: Int = 0) {
        deleteCompletions[index](nil)
    }
    
    func insertItems(_ items: [FeedItem]) {
        insertCallCount += 1
    }
}

class LocalFeedLoader {
    private let store: FeedStore

    init(store: FeedStore) {
        self.store = store
    }
    
    func save(_ items: [FeedItem]) {
        store.deleteCashedFeed { [unowned self] error in
            if error == nil {
                self.store.insertItems(items)
            }
        }
    }
}

class CacheFeedUseCaseTests: XCTestCase {
    
    func test_init_doesNotDeleteCacheUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.deleteCashedFeedCallCount, 0)
    }
    
    func test_save_requestsCacheDeletion() {
        let items = [uniqueItem(), uniqueItem()]
        let (sut, store) = makeSUT()
    
        sut.save(items)
       
        XCTAssertEqual(store.deleteCashedFeedCallCount, 1)
    }
    
    func test_save_DoesNotRequestCacheInsertionOnDelitionError() {
        let items = [uniqueItem(), uniqueItem()]
        let (sut, store) = makeSUT()
        let deletionError = anyNSError()
        
        sut.save(items)
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(store.insertCallCount, 0)
    }
    
    func test_save_RequestsNewCacheInsertionOnSuccessfulDeletion() {
        let items = [uniqueItem(), uniqueItem()]
        let (sut, store) = makeSUT()
       
        sut.save(items)
        store.completeDeletionSeccesfully()
        
        XCTAssertEqual(store.insertCallCount, 1)
    }
    
// MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStore) {
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store)
        
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, store)
    }
    
    private func uniqueItem() -> FeedItem {
        return FeedItem(id: UUID(), description: "any", location: "any", imageURL: anyURL())
    }
    
    private func anyURL() -> URL {
        return URL(string: "http://any-url.com")!
    }
    
    private func anyNSError() -> NSError  {
        return NSError(domain: "any error", code: 0)
    }
}
