//
//  FeedEndpoint.swift
//  EssentialFeed
//
//  Created by Marija Zdravic on 15.02.2026..
//
import Foundation

public enum FeedEndpoint {
    case get(after: FeedImage? = nil)

    public func url(baseURL: URL) -> URL {
        var components = URLComponents()
        components.scheme = baseURL.scheme
        components.host = baseURL.host
        components.port = baseURL.port
        components.path = baseURL.path + "/v1/feed"

        let afterIdItem = afterImageQueryItem
        components.queryItems = [
            URLQueryItem(name: "limit", value: "10"),
            afterIdItem
        ].compactMap { $0 }

        return components.url!
    }

    private var afterImageQueryItem: URLQueryItem? {
        switch self {
        case let .get(after: image):
            return image.map { URLQueryItem(name: "after_id", value: $0.id.uuidString) }
        }
    }
}
