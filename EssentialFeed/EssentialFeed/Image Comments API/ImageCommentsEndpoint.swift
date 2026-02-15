//
//  ImageCommentsEndpoint.swift
//  EssentialFeed
//
//  Created by Marija Zdravic on 15.02.2026..
//

import Foundation

public enum ImageCommentsEndpoint {
    case get(_ image: FeedImage)

    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(image):
            return baseURL.appendingPathComponent("/v1/image/\(image.id)/comments")
        }
    }
}
