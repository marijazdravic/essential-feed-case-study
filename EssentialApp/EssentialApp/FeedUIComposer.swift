//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Marija Zdravic on 14.07.2025..
//

import Combine
import EssentialFeed
import EssentialFeediOS
import Foundation
import UIKit

public final class FeedUIComposer {
    private init() {}

    private typealias FeedPresentationAdapter = LoadResourcePresentationAdapter<
        [FeedImage], FeedViewAdapter
    >

    public static func feedComposedWith(
        feedLoader: @escaping () -> AnyPublisher<[FeedImage], Error>,
        imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher,
        selection: @escaping (FeedImage) -> Void = { _ in }
    ) -> ListViewController {
        let presentationAdapter = FeedPresentationAdapter(loader: feedLoader)

        let feedController = makeListViewController(
            title: FeedPresenter.title
        )
        feedController.onRefresh = presentationAdapter.loadResource
        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: FeedViewAdapter(
                controller: feedController,
                imageLoader: imageLoader,
                selection: selection,
            ),
            loadingView: WeakRefVirtualProxy(feedController),
            errorView: WeakRefVirtualProxy(feedController),
            mapper: FeedPresenter.map
        )

        return feedController
    }

    private static func makeListViewController(title: String)
        -> ListViewController
    {
        let bundle = Bundle(for: ListViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedController =
            storyboard.instantiateInitialViewController() as! ListViewController
        feedController.title = title

        return feedController
    }
}
