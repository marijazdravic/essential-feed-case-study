//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by Marija Zdravic on 15.07.2025..
//

import Foundation
import EssentialFeed

struct FeedLoadingViewModel {
    let isLoading: Bool
}


protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel)
}

struct FeedViewModel {
    let feed: [FeedImage]
}


protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}

final class FeedPresenter {
    var view: FeedView?
    var loadingView: FeedLoadingView?

    
    func didStartLoadingFeed() {
        loadingView?.display(FeedLoadingViewModel(isLoading: true))
    }
    
    func didFinishLoadingFeed(with feed: [FeedImage]) {
        view?.display(FeedViewModel(feed: feed))
        loadingView?.display(FeedLoadingViewModel(isLoading: false))
    }
    
    func didFinishLoading(with error: Error) {
        loadingView?.display(FeedLoadingViewModel(isLoading: false))
    }
}
