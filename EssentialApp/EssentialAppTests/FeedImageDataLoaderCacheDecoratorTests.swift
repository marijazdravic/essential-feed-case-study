//
//  FeedImageDataLoaderCacheDecoratorTests.swift
//  EssentialAppTests
//
//  Created by Marija Zdravic on 25.11.2025..
//

import XCTest
import EssentialFeed

protocol FeedImageCache {
    typealias SaveResult = Result<Void, Swift.Error>
    
    func save(_ data: Data, for url: URL, completion: @escaping (SaveResult) -> Void)
}

class FeedImageDataLoaderCacheDecorator: FeedImageDataLoader {
    let decoratee: FeedImageDataLoader
    let cache: FeedImageCache
    
    init(decoratee: FeedImageDataLoader, cache: FeedImageCache) {
        self.decoratee = decoratee
        self.cache = cache
    }
    
    func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
        return decoratee.loadImageData(from: url) { [ weak self ] result in
            self?.cache.save((try? result.get()) ?? Data(), for: url) { _ in }
            completion(result)
        }
    }
}

class FeedImageDataLoaderCacheDecoratorTests: XCTestCase {
    
    func test_init_doesNotLoadImageData() {
        let (_, loader) = makeSUT()
        
        XCTAssertTrue(loader.loadedURLs.isEmpty, "Expected no loaded URLs")
    }
    
    func test_loadImageData_loadsFromLoader() {
        let url = anyURL()
        let (sut, loader) = makeSUT()
        
        
        _ = sut.loadImageData(from: url) { _ in }
        
        XCTAssertEqual(loader.loadedURLs, [url], "Expected to load URL from loader")
    }
    
    func test_cancelLoadImageData_cancelsLoadersTask() {
        let (sut, loader) = makeSUT()
        let url = anyURL()
        
        let task = sut.loadImageData(from: url) { _ in }
        task.cancel()
        
        XCTAssertEqual(loader.canceledImageURLs, [url], "Expected to load URL from loader")
    }
    
    func test_loadImageData_deliversImageDataOnLoaderSuccess() {
        let imageData = anyData()
        let (sut, loader) = makeSUT()
        
        expect(sut, toCompleteWith: .success(imageData), when: {
            loader.complete(with: imageData)
        })
    }
    
    func test_loadImageData_deliversErrorOnLoaderFailure() {
        let error = anyNSError()
        let (sut, loader) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(error), when: { loader.complete(with: error) })
    }
    
    // MARK: - Helpers
    
    private func makeSUT(cache: FeedCacheSpy = .init(), file: StaticString = #file, line: UInt = #line) -> (sut: FeedImageDataLoader, loader: FeedImageDataLoaderSpy) {
        let loader = FeedImageDataLoaderSpy()
        let sut = FeedImageDataLoaderCacheDecorator(decoratee: loader, cache: cache)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, loader)
    }
    
    private func expect(_ sut: FeedImageDataLoader, toCompleteWith expectedResult: FeedImageDataLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        _ = sut.loadImageData(from: anyURL()) { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedFeed), .success(expectedFeed)):
                XCTAssertEqual(receivedFeed, expectedFeed, file: file, line: line)
                
            case (.failure, .failure):
                break
                
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    class FeedCacheSpy: FeedImageCache {
        private(set) var messages = [Message]()
        
        enum Message: Equatable {
            case save(data: Data, for: URL)
        }
        
        func save(_ data: Data, for url: URL, completion: @escaping (SaveResult) -> Void) {
            messages.append(.save(data: data, for: url))
            completion(.success(()))
        }
    }
    
    private class FeedImageDataLoaderSpy: FeedImageDataLoader {
        private var messages = [(url: URL, completion: (FeedImageDataLoader.Result) -> Void)]()
        
        var loadedURLs: [URL]{
            return messages.map { $0.url }
        }
        private(set) var canceledImageURLs = [URL]()
        
        private struct Task: FeedImageDataLoaderTask {
            let callback: () -> Void
            
            func cancel() {
                callback()
            }
        }
        
        func loadImageData(from url: URL, completion: @escaping (FeedImageDataLoader.Result) -> Void) -> FeedImageDataLoaderTask {
            messages.append((url, completion))
            
            return Task() { [weak self] in
                self?.canceledImageURLs.append(url)
            }
        }
        
        func complete(with data: Data, index: Int = 0) {
            messages[index].completion(.success(data))
        }
        
        func complete(with error: Error, index: Int = 0) {
            messages[index].completion(.failure(error))
        }
    }
}
