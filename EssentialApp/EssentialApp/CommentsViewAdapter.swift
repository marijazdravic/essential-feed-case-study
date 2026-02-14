//
//  CommentsViewAdapter.swift
//  EssentialApp
//
//  Created by Marija Zdravic on 14.02.2026..
//

import Foundation
import EssentialFeed
import EssentialFeediOS

final class CommentsViewAdapter: ResourceView {
    private weak var controller: ListViewController?

    init(controller: ListViewController) {
        self.controller = controller
    }

    func display(_ viewModel: ImageCommentsViewModel) {
        controller?.display(
            viewModel.comments.map { viewModel in
                CellController(
                    id: viewModel,
                    dataSource: ImageCommentCellController(model: viewModel)
                )
            }
        )
    }
}
