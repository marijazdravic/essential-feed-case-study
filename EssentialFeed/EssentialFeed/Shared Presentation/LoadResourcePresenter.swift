//
//  LoadResourcePresenter.swift
//  EssentialFeed
//
//  Created by Marija Zdravic on 19.01.2026..
//
import Foundation

public final class LoadResourcePresenter {
    private let view: FeedView
    private let errorView: FeedErrorView
    private let loadingView: FeedLoadingView
    
    private var feedLoadError: String {
        return NSLocalizedString("FEED_VIEW_CONNECTION_ERROR",
                                 tableName: "Feed",
                                 bundle: Bundle(for: FeedPresenter.self),
                                 comment: "Error message displayed when we can't load the image feed from the server")
    }
    
    
    public init(view: FeedView, errorView: FeedErrorView, loadingView: FeedLoadingView) {
        self.view = view
        self.errorView = errorView
        self.loadingView = loadingView
    }
    
    public func didStartLoading() {
        errorView.display(.noError)
        loadingView.display(FeedLoadingViewModel(isLoading: true))
    }
    
    public func didFinishLoadingFeed(with feed: [FeedImage]) {
        view.display(FeedViewModel(feed: feed))
        loadingView.display(FeedLoadingViewModel(isLoading: false))
    }
    
    public func didFinishLoadingFeed(with error: Error) {
        loadingView.display(FeedLoadingViewModel(isLoading: false))
        errorView.display(.error(message: feedLoadError))
    }
}


