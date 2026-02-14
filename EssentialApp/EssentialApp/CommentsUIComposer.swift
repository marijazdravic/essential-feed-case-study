//
//  CommentsUIComposer.swift
//  EssentialApp
//
//  Created by Marija Zdravic on 28.01.2026..
//

import Foundation
import UIKit
import EssentialFeed
import EssentialFeediOS
import Combine

public final class CommentsUIComposer {
    private init() {}
    
    private typealias FeedPresentationAdapter = LoadResourcePresentationAdapter<[FeedImage], FeedViewAdapter>
    
    public static func commentsComposedWith(feedLoader: @escaping () -> AnyPublisher<[FeedImage], Error>) -> ListViewController {
        let presentationAdapter = FeedPresentationAdapter(loader: feedLoader)
        
        let feedController = makeListViewController(
            title: ImageCommentsPresenter.title)
            feedController.onRefresh = presentationAdapter.loadResource
        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: FeedViewAdapter(
                controller: feedController,
                imageLoader: { _ in Empty<Data, Error>().eraseToAnyPublisher() }),
                loadingView: WeakRefVirtualProxy(feedController),
                errorView: WeakRefVirtualProxy(feedController),
                mapper: FeedPresenter.map)
     
        return feedController
    }

    private static func makeListViewController(title: String) -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! ListViewController
        feedController.title = title
        
        return feedController
    }
}


