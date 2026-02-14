//
//  ListViewController+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Marija Zdravic on 14.07.2025..
//

import EssentialFeediOS
import Foundation
import UIKit

extension ListViewController {
    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }

    func simulateUserInitiatedReload() {
        refreshControl?.simulatePullToRefresh()
    }

    func simulateViewAppearance() {
        if !isViewLoaded {
            loadViewIfNeeded()

            prepareForFirstAppearance()
        }

        beginAppearanceTransition(true, animated: false)
        endAppearanceTransition()
    }

    private func prepareForFirstAppearance() {
        setSmallFrameToPreventRenderingCells()
        replaceRefreshControlWithFakeForiOS17Support()
    }

    func cell(at row: Int, section: Int) -> UITableViewCell? {
        guard numberOfRenderedImageViews() > row else {
            return nil
        }

        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: section)
        return ds?.tableView(tableView, cellForRowAt: index)
    }

    func simulateErrorViewTapped() {
        errorView.simulateTap()
    }

    var errorMessage: String? {
        return errorView.message
    }

    private func setSmallFrameToPreventRenderingCells() {
        tableView.frame = CGRect(x: 0, y: 0, width: 390, height: 1)
    }

}

extension ListViewController {
    func simulateFeedImageViewNotNearVisible(at row: Int) {
        simulateFeedImageViewNearVisible(at: row)
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: feedImageSection)
        ds?.tableView?(tableView, cancelPrefetchingForRowsAt: [index])
    }

    func simulateFeedImageViewNearVisible(at row: Int) {
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: feedImageSection)
        ds?.tableView(tableView, prefetchRowsAt: [index])
    }

    @discardableResult
    func simulateFeedImageViewIsVisible(at index: Int) -> FeedImageCell? {
        return feedImageView(at: index)
    }

    @discardableResult
    func simulateFeedImageViewNotVisible(at row: Int) -> FeedImageCell? {
        let view = simulateFeedImageViewIsVisible(at: row)

        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: feedImageSection)
        delegate?.tableView?(
            tableView,
            didEndDisplaying: view!,
            forRowAt: index
        )

        return view
    }

    @discardableResult
    func simulateFeedImageBecomingVisibleAgain(at row: Int) -> FeedImageCell? {
        let view = simulateFeedImageViewNotVisible(at: row)

        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: feedImageSection)
        delegate?.tableView?(tableView, willDisplay: view!, forRowAt: index)

        return view
    }
    
    private var feedImageSection: Int {
        return 0
    }

    func feedImageView(at row: Int) -> FeedImageCell? {
        cell(at: row, section: feedImageSection) as? FeedImageCell
    }
    
    func numberOfRenderedImageViews() -> Int {
        tableView.numberOfSections == 0
            ? 0 : tableView.numberOfRows(inSection: feedImageSection)
    }

    func renderedFeedImageData(at index: Int) -> Data? {
        return simulateFeedImageViewIsVisible(at: index)?.renderedImage
    }
}

extension ListViewController {
    private var commentsSection: Int { 0 }

    func numberOfRenderedComments() -> Int {
        tableView.numberOfSections == 0
            ? 0 : tableView.numberOfRows(inSection: commentsSection)
    }

    func commentMessage(at index: Int) -> String? {
        commentImageView(at: index)?.messageLabel.text
    }

    func commentUsername(at index: Int) -> String? {
        commentImageView(at: index)?.userNameLabel.text
    }

    func commentDate(at index: Int) -> String? {
        commentImageView(at: index)?.dateLabel.text
    }

    func commentImageView(at row: Int) -> ImageCommentCell? {
        cell(at: row, section: commentsSection) as? ImageCommentCell
    }

}

extension ListViewController {
    func replaceRefreshControlWithFakeForiOS17Support() {
        let fake = FakeRefreshControl()

        refreshControl?.allTargets.forEach { target in
            refreshControl?
                .actions(forTarget: target, forControlEvent: .valueChanged)?
                .forEach { action in
                    fake.addTarget(
                        target,
                        action: Selector(action),
                        for: .valueChanged
                    )
                }
        }

        refreshControl = fake
    }
}
