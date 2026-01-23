//
//  ImageCommentsPresenter.swift
//  EssentialFeed
//
//  Created by Marija Zdravic on 23.01.2026..
//
import Foundation

public final class ImageCommentsPresenter {
    public static var title: String {
        return NSLocalizedString("IMAGE_COMMENTS_VIEW_TITLE",
                                 tableName: "ImageComments",
                                 bundle: Bundle(for: Self.self),
                                 comment: "Title for the image comments view")
    }
}

