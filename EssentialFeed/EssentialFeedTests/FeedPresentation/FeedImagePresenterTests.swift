//
//  FeedImagePresenterTests.swift
//  EssentialFeedTests
//
//  Created by Marija Zdravic on 05.11.2025..
//

import XCTest

class FeedImagePresenter {
    init (view: Any) {
        
    }
}

class FeedImagePresenterTests: XCTestCase {
    
    func test_init_doesNotSendMesssagesToView() {
        let (_, view) = makeSUT()
       
        XCTAssertTrue(view.message.isEmpty)
    }
    
    // MARK: -Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt =  #line) -> (sut: FeedImagePresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedImagePresenter(view: view)
        
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return (sut, view)
    }
    
    private class ViewSpy {
        let message = [Any]()
    }
}
