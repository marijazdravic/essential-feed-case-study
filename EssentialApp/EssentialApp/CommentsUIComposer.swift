//
//  CommentsUIComposer.swift
//  EssentialApp
//
//  Created by Marija Zdravic on 28.01.2026..
//

import Combine
import EssentialFeed
import EssentialFeediOS
import Foundation
import UIKit

public final class CommentsUIComposer {
    private init() {}

    private typealias CommentsPresentationAdapter =
        LoadResourcePresentationAdapter<[ImageComment], CommentsViewAdapter>

    public static func commentsComposedWith(
        commentsLoader: @escaping () -> AnyPublisher<[ImageComment], Error>
    ) -> ListViewController {
        let presentationAdapter = CommentsPresentationAdapter(
            loader: commentsLoader
        )

        let commentsController = makeListViewController(
            title: ImageCommentsPresenter.title
        )
        commentsController.onRefresh = presentationAdapter.loadResource
        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: CommentsViewAdapter(
                controller: commentsController
            ),
            loadingView: WeakRefVirtualProxy(commentsController),
            errorView: WeakRefVirtualProxy(commentsController),
            mapper: { ImageCommentsPresenter.map($0) }
        )

        return commentsController
    }

    private static func makeListViewController(title: String)
        -> ListViewController
    {
        let bundle = Bundle(for: ListViewController.self)
        let storyboard = UIStoryboard(name: "ImageComments", bundle: bundle)
        let commentsController =
            storyboard.instantiateInitialViewController() as! ListViewController
        commentsController.title = title

        return commentsController
    }
}
