//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by Marija Zdravic on 28.06.2025..
//

import XCTest
import EssentialFeed
import UIKit

final class FeedViewController: UITableViewController {
    private var loader: FeedLoader?
    private var onViewIsAppearing: ((FeedViewController) -> Void)?
    
    convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        
        onViewIsAppearing = { vc in
            vc.refresh()
            vc.onViewIsAppearing = nil
        }
        
        load()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        onViewIsAppearing?(self)
    }
    
    @objc private func load() {
        loader?.load { [weak self] _ in
            self?.refreshControl?.endRefreshing()
        }
    }
    
    @objc private func refresh() {
        refreshControl?.beginRefreshing()
    }
}

extension FeedViewController {
    func replaceRefreshControlWithFakeForiOS17Support() {
        let fake = FakeRefreshcontrol()
        
        refreshControl?.allTargets.forEach { target in
            refreshControl?
                .actions(forTarget: target, forControlEvent: .valueChanged)?
                .forEach { action in
                    fake.addTarget(self, action: Selector(action), for: .valueChanged)
                }
        }
        
        refreshControl = fake
    }
}

class FeedViewControllerTests: XCTestCase {
    
    func test_init_doesNotLoadFeed() {
        let (_, loader) = makeSUT()
        
        XCTAssertEqual(loader.loadCount, 0)
    }
    
    func test_viewDidLoad_loadsFeed() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loader.loadCount, 1)
    }
    
    func test_userInitiatedFeedReload_loadsFeed() {
        let (sut, loader) = makeSUT()
        sut.loadViewIfNeeded()
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.loadCount, 2)
        
        sut.refreshControl?.simulatePullToRefresh()
        XCTAssertEqual(loader.loadCount, 3)
    }
    
    func test_refreshControlIsNotRefreshingBeforeViewAppears() {
        let (sut, _) = makeSUT()
        sut.replaceRefreshControlWithFakeForiOS17Support()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.isShowingLoadingIndicator, false)
    }
    
    func test_viewIsAppearing_showsLoadingIndicatorOnViewApears() {
        let (sut, _) = makeSUT()
        sut.replaceRefreshControlWithFakeForiOS17Support()
        
        simulateViewAppearance(sut: sut)
        
        XCTAssertEqual(sut.isShowingLoadingIndicator, true)
    }
    
    func test_viewIsAppearing_doesNotShowLoadingIndicatorOnEveryAppearance() {
        let (sut, _) = makeSUT()
        sut.replaceRefreshControlWithFakeForiOS17Support()
        sut.loadViewIfNeeded()
        
        simulateViewAppearance(sut: sut)
        
        sut.refreshControl?.endRefreshing()
        
        simulateViewAppearance(sut: sut)
        
        XCTAssertEqual(sut.isShowingLoadingIndicator, false)
    }
    
    func test_viewDidLoad_hidesLoadingIndicatorOnLoaderCompletion() {
        let (sut, loader) = makeSUT()
        sut.replaceRefreshControlWithFakeForiOS17Support()
        
        simulateViewAppearance(sut: sut)
        loader.completeFeedLoading()
        
        XCTAssertEqual(sut.isShowingLoadingIndicator, false)
    }
    
    func test_userInitiatedFeedReload_showsLoadingIndicator() {
        let (sut, _) = makeSUT()
        sut.replaceRefreshControlWithFakeForiOS17Support()
        
        simulateViewAppearance(sut: sut)
        sut.simulateUserInitiatedFeedReload()
        
        XCTAssertEqual(sut.isShowingLoadingIndicator, true)
    }
    
    func test_userInitiatedFeedReload_hidesLoadingIndicatorOnLoaderCompletion() {
        let (sut, loader) = makeSUT()
        sut.replaceRefreshControlWithFakeForiOS17Support()
        
        sut.simulateUserInitiatedFeedReload()
        loader.completeFeedLoading()
        
        XCTAssertEqual(sut.isShowingLoadingIndicator, false)
    }
    
    // MARK: -Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FeedViewController(loader: loader)
        trackForMemoryLeaks(loader)
        trackForMemoryLeaks(sut)
        
        return(sut, loader)
    }
    
    private func simulateViewAppearance(sut: FeedViewController) {
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
    }
    
    class LoaderSpy: FeedLoader {
        private var completions = [(FeedLoader.Result) -> Void]()
        var loadCount: Int {
            completions.count
        }
        
        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            completions.append(completion)
        }
        
        func completeFeedLoading() {
            completions[0](.success([]))
        }
    }
}

private extension FeedViewController {
    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }
    
    func simulateUserInitiatedFeedReload() {
        refreshControl?.simulatePullToRefresh()
    }
}

private extension UIRefreshControl {
    func simulatePullToRefresh() {
        allTargets.forEach { target in
            actions(
                forTarget: target,
                forControlEvent: .valueChanged)?
                .forEach({ (target as NSObject).perform(Selector($0))})
        }
    }
}

private class FakeRefreshcontrol: UIRefreshControl {
    private var _isRefreshing = false
    
    override var isRefreshing: Bool { _isRefreshing }
    
    override func beginRefreshing() {
        _isRefreshing = true
    }
    
    override func endRefreshing() {
        _isRefreshing = false
    }
}
