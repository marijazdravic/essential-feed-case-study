//
//  FeedPresenter.swift
//  EssentialFeed
//
//  Created by Marija Zdravic on 05.11.2025..
//

import Foundation

public protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}


public final class FeedPresenter {
    private let view: FeedView
    private let errorView: ResourceErrorView
    private let loadingView: ResourceLoadingView
    
    public static var title: String {
        return NSLocalizedString("FEED_VIEW_TITLE",
                                 tableName: "Feed",
                                 bundle: Bundle(for: FeedPresenter.self),
                                 comment: "Title for the feed view")
    }
    
    private var feedLoadError: String {
        return NSLocalizedString("GENERIC_CONNECTION_ERROR",
                                 tableName: "Shared",
                                 bundle: Bundle(for: FeedPresenter.self),
                                 comment: "Error message displayed when we can't load the image feed from the server")
    }
    
    
    public init(view: FeedView, errorView: ResourceErrorView, loadingView: ResourceLoadingView) {
        self.view = view
        self.errorView = errorView
        self.loadingView = loadingView
    }
    
    public func didStartLoadingFeed() {
        errorView.display(.noError)
        loadingView.display(ResourceLoadingViewModel(isLoading: true))
    }
    
    public func didFinishLoadingFeed(with feed: [FeedImage]) {
        view.display(FeedViewModel(feed: feed))
        loadingView.display(ResourceLoadingViewModel(isLoading: false))
    }
    
    public func didFinishLoadingFeed(with error: Error) {
        loadingView.display(ResourceLoadingViewModel(isLoading: false))
        errorView.display(.error(message: feedLoadError))
    }
}

