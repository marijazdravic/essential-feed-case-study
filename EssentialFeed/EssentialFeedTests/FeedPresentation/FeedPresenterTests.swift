//
//  FeedPresentaterTests.swift
//  EssentialFeedTests
//
//  Created by Marija Zdravic on 04.11.2025..
//

import XCTest

final class FeedPresenter {
    init(view: Any) {
        
    }
}

class FeedPresenterTests: XCTestCase {
    
    func test_init_doesNotSendMessagesToViews() {
        let view = ViewSpy()
        
        _ = FeedPresenter(view: view)
        
        XCTAssertTrue(view.messages.isEmpty)
    }
    
    // Mark: -Helpers
    
    private class ViewSpy {
        let messages = [Any]()
    }
}
