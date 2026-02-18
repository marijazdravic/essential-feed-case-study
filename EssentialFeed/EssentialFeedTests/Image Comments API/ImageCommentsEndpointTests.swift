//
//  ImageCommentsEndpointTests.swift
//  EssentialFeedTests
//
//  Created by Marija Zdravic on 18.02.2026..
//

import XCTest
import EssentialFeed

class ImageCommentsEndpointTests: XCTestCase {
    func test_feed_endpointURL() {
        let image = FeedImage(
            id: UUID(uuidString: "12345678-1234-1234-1234-123456789012")!,
            description: nil,
            location: nil,
            url: anyURL())
        
        let received = ImageCommentsEndpoint.get(image).url(baseURL: baseURL())
        let expected = URL(string: "http://base-url.com/v1/image/12345678-1234-1234-1234-123456789012/comments")!
        
        XCTAssertEqual(received, expected)
    }
}
