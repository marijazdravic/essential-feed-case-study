//
//  FeedEndpointTests.swift
//  EssentialFeedTests
//
//  Created by Marija Zdravic on 21.02.2026..
//


import XCTest
import EssentialFeed

class FeedEndpointTests: XCTestCase {
    func test_feed_endpointURL() {
        let received = FeedEndpoint.get.url(baseURL: baseURL())
        let expected = URL(string: "http://base-url.com/v1/feed")!

        XCTAssertEqual(received, expected)
    }
}
