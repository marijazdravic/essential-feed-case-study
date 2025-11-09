//
//  RemoteFeedImageDataLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Marija Zdravic on 07.11.2025..
//

import XCTest
import EssentialFeed

class RemoteFeedImageDataLoader {
    let client: HTTPClient
    
    init(client: HTTPClient) {
        self.client = client
    }
    
    func loadImageData(from url: URL,completion: @escaping (FeedImageDataLoader.Result) -> Void) {
        client.get(from: url) { result in
            switch result {
            case let .failure(error):
                completion(.failure(error))
                
            default: break
            }
        }
    }
}

class RemoteFeedImageDataLoaderTests: XCTestCase {
    
    func test_init_doesNotPerformAnyURLRequest() {
        let (_, client) = makeSUT()
        
        XCTAssertTrue(client.requestedURLs.isEmpty)
        
    }
    
    func test_loadImageDataFromURL_requestsDataFromURL() {
        let (sut, client) = makeSUT()
        let url = URL(string: "https://a-given-url.com")!
        
        sut.loadImageData(from: url) { _ in }
        
        XCTAssertEqual(client.requestedURLs.first, url)
    }
    
    func test_loadImageDataFromURLTwice_requestsDataFromURTwiceL() {
        let (sut, client) = makeSUT()
        let url = URL(string: "https://a-given-url.com")!
        
        sut.loadImageData(from: url) { _ in }
        sut.loadImageData(from: url) { _ in }
        
        XCTAssertEqual(client.requestedURLs.count, 2)
    }
    
    func test_loadImageDataFromURL_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        let clientError = anyNSError()
        
        expect(sut, toCompleteWith: .failure(clientError), when: {
            client.complete(with: clientError)
        })
    }
    
    //MARK: -Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: RemoteFeedImageDataLoader, client: HTTPClientSpy){
        let client = HTTPClientSpy()
        let sut = RemoteFeedImageDataLoader(client: client)
        trackForMemoryLeaks(sut,file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }
    
    private func expect(
        _ sut: RemoteFeedImageDataLoader,
        toCompleteWith expectedResult: FeedImageDataLoader.Result,
        when action: ()-> Void, file: StaticString = #file, line: UInt = #line) {
            let url = URL(string: "https://a-given-url.com")!
            let exp = expectation(description: "Wait for load completion")
            
            sut.loadImageData(from: url) { receivedResult in
                switch (expectedResult, receivedResult) {
                    case let (.success(receivedData), .success(expectedData)):
                        XCTAssertEqual(receivedData, expectedData, file: file, line: line)

                    case let (
                        .failure(expectedError as NSError),
                        .failure(receivedError as NSError)
                    ):
                        XCTAssertEqual(expectedError, receivedError)
                    default:
                        XCTFail("Expected result \(expectedResult) got \(receivedResult) instead")
                }
                
                exp.fulfill()
            }
            
            action()
            wait(for: [exp], timeout: 1.0)
        }
    
    private class HTTPClientSpy: HTTPClient {
        var messages = [(url: URL, completion: (HTTPClient.Result) -> Void)]()
        
        var requestedURLs: [URL] {
            return messages.map { $0.url }
        }
        
        func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
    }
}
