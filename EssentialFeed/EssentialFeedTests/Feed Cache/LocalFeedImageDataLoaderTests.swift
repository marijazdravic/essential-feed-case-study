//
//  LocalFeedImageDataLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Marija Zdravic on 13.11.2025..
//

import XCTest
import EssentialFeed

protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>
    
    func retrieve(dataForUrl url: URL, completion: @escaping (Result) -> Void)
}

final class LocalFeedImageDataLoader: FeedImageDataLoader {
    private struct Task: FeedImageDataLoaderTask {
        func cancel() {}
    }
    
    public enum Error: Swift.Error {
        case failed
    }
    
    private let store: FeedImageDataStore
    
    init(store: FeedImageDataStore) {
        self.store = store
    }
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> EssentialFeed.FeedImageDataLoaderTask {
        
        store.retrieve(dataForUrl: url) { result in
            completion(.failure(Error.failed))
        }
        
        return Task()
    }
}

class LocalFeedImageDataLoaderTests: XCTestCase {
    
    func test_init_doesNotMessgeStoreUponCreation() {
        
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    func test_loadImageDataFromURL_requestsStoredDataForURL() {
        let (sut, store) = makeSUT()
        let url = anyURL()
        
        _ = sut.loadImageData(from: url) { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.retrieve(dataFor: url)])
    }
    
    func test_loadImageDataFromURL_failsOnStoreError() {
        let (sut, store) = makeSUT()
        let retrievalError = anyNSError()
        
        expect(sut, toCompleteWith: failed(), when: {
            store.complete(with: retrievalError)
        })
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedImageDataLoader, store: StoreSpy) {
        let store = StoreSpy()
        let sut = LocalFeedImageDataLoader(store: store)
        return (sut, store)
    }
    
    private func expect(_ sut: LocalFeedImageDataLoader, toCompleteWith expectedResult: FeedImageDataLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        var receivedResult: FeedImageDataLoader.Result?
        
        _ = sut.loadImageData(from: anyURL()) { result in
            receivedResult = result
            switch (receivedResult, expectedResult) {
            case let (.success(receivedData), .success(expectedData)):
                XCTAssertEqual(receivedData, expectedData, file: file, line: line)
                
            case (.failure(let receivedError as LocalFeedImageDataLoader.Error),
                  .failure(let expectedError as LocalFeedImageDataLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected \(String(describing: expectedResult)), got \(String(describing: receivedResult)) instead")
            }
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
    }
    
    private func failed() -> FeedImageDataLoader.Result {
        return .failure(LocalFeedImageDataLoader.Error.failed)
    }
    
    private class StoreSpy: FeedImageDataStore {
        enum Message: Equatable {
            case retrieve(dataFor: URL)
        }
        
        private var completions = [(FeedImageDataStore.Result) -> Void]()
        var receivedMessages = [Message]()
        
        func retrieve(dataForUrl url: URL, completion: @escaping (FeedImageDataStore.Result) -> Void) {
            receivedMessages.append(.retrieve(dataFor: url))
            completions.append(completion)
        }
        
        func complete(with error: Error, at index: Int = 0) {
            completions[index](.failure(error))
        }
    }
}
