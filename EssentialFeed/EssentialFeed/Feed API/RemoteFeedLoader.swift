//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Marija Zdravic on 20.05.2025..
//

import Foundation

public typealias RemoteFeedLoader = RemoteLoader<[FeedImage]>

public extension RemoteFeedLoader {
    convenience init(url:URL, client: HTTPClient) {
        self.init(url: url, client: client, mapper: FeedItemsMapper.map)
    }
}
                    
