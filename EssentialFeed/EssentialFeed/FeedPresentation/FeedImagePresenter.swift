//
//  FeedImagePresenter.swift
//  EssentialFeed
//
//  Created by Marija Zdravic on 06.11.2025..
//
import Foundation

public final class FeedImagePresenter {
    
    public static func map(_ image: FeedImage) -> FeedImageViewModel {
        FeedImageViewModel(
            description: image.description,
            location: image.location)
    }
}

