//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by Marija Zdravic on 28.06.2025..
//

import XCTest
import EssentialFeed

final class FeedViewController {
    
    init(loader: FeedViewControllerTests.LoaderSpy) {
    }
}

class FeedViewControllerTests: XCTestCase {
    
    func test_init_doesNotLoadFeed() {
        let loader = LoaderSpy()
        _ = FeedViewController(loader: loader)
        
        XCTAssertEqual(loader.loadCount, 0)
    }
    
    // MARK: -Helpers
    
    class LoaderSpy {
        var loadCount = 0
    }
}
