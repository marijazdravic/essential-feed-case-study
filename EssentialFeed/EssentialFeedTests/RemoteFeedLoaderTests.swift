//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Marija Zdravic on 20.05.2025..
//

import Foundation

import Foundation
import XCTest

class RemoteFeedLoader {
    
}

class HTTPClient {
    var requestedURL: URL?
}

class RemoteFeedLoaderTests: XCTestCase {
    
    func test_init_DoesNotRequestDataFromURL() {
        let client = HTTPClient()
        let _ = RemoteFeedLoader()
        
        XCTAssertNil(client.requestedURL)
    }
}

