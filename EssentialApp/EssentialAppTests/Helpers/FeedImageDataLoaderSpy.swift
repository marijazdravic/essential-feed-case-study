//
//  FeedImageDataLoaderSpy.swift
//  EssentialAppTests
//
//  Created by Marija Zdravic on 26.11.2025..
//

import Foundation
import EssentialFeed

class FeedImageDataLoaderSpy: FeedImageDataLoader {
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
