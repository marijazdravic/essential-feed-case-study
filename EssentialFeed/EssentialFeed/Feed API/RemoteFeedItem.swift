//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Marija Zdravic on 10.06.2025..
//

import Foundation

struct RemoteFeedItem: Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
}

