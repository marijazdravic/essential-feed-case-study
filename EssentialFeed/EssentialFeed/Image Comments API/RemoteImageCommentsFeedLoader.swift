//
//  RemoteImageCommentsLoader.swift
//  EssentialFeed
//
//  Created by Marija Zdravic on 15.01.2026..
//

import Foundation

public typealias RemoteImageCommentsLoader = RemoteLoader<[ImageComment]>

public extension RemoteImageCommentsLoader {
    convenience init(url: URL, client: HTTPClient) {
        self.init(url: url, client: client, mapper: ImageCommentsMapper.map)
    }
}
