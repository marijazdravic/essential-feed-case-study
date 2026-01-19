//
//  LoadResourcePresentationTests.swift
//  EssentialFeedTests
//
//  Created by Marija Zdravic on 19.01.2026..
//

import XCTest
import EssentialFeed

class LoadResourcePresenterTests: XCTestCase {

    func test_init_doesNotSendMessagesToViews() {
        let (_, view) = makeSUT()
        
        
        XCTAssertTrue(view.messages.isEmpty)
    }
    
    func test_didStartLoading_displaysNoErrorMessageAndStartsLoading() {
        
        let (sut, view) = makeSUT()
        
        sut.didStartLoading()
        
        XCTAssertEqual(view.messages, [
            .display(errorMessage: .none),
            .display(isLoading: true)
        ])
    }
    
    func test_didFinishLoadingFeed_displaysFeedAndStopsLoading() {
        
        let (sut, view) = makeSUT()
        let feed = uniqueImageFeed().models
        
        sut.didFinishLoadingFeed(with: feed)

        
        XCTAssertEqual(view.messages, [
            .display(feed: feed),
            .display(isLoading: false)
        ])
    }
    
    func test_didFinishLoadingFeedWithError_displaysLocalizedErrorMessageAndStopsLoading() {
        let (sut, view) = makeSUT()
        
        let error = anyNSError()
        sut.didFinishLoadingFeed(with: error)
        
        XCTAssertEqual(view.messages, [
            .display(isLoading: false),
            .display(errorMessage: localized("FEED_VIEW_CONNECTION_ERROR"))
        ])
    }
    
    // Mark: -Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: LoadResourcePresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = LoadResourcePresenter(
            view: view,
            errorView: view,
            loadingView: view
        )
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }
    
    private func localized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
        let table = "Feed"
        let bundle = Bundle(for: LoadResourcePresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
    
    private class ViewSpy: FeedView, FeedErrorView, FeedLoadingView {
        enum Message: Hashable {
            case display(errorMessage: String?)
            case display(isLoading: Bool)
            case display(feed: [FeedImage])
        }
        private(set)var messages = Set<Message>()
        
        func display(_ viewModel: FeedErrorViewModel) {
            messages.insert(.display(errorMessage: viewModel.message))
        }
        
        func display(_ viewModel: FeedLoadingViewModel) {
            messages.insert(.display(isLoading: viewModel.isLoading))
        }
        
        func display(_ viewModel: FeedViewModel) {
            messages.insert(.display(feed: viewModel.feed))
        }
    }

}
