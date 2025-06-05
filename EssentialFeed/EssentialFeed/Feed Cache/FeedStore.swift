//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Marija Zdravic on 05.06.2025..
//

import Foundation

public protocol FeedStore {
    typealias DeleteCompletion = (Error?) -> Void
    typealias InsertCompletion = (Error?) -> Void
    
    func deleteCashedFeed(completion: @escaping DeleteCompletion)
    func insertItems(_ items: [LocalFeedItem], timestamp: Date, completion: @escaping InsertCompletion)
}

public struct LocalFeedItem: Equatable {
    public let id: UUID
    public let description: String?
    public let location: String?
    public let imageURL: URL
    
    public init(id: UUID, description: String?, location: String?, imageURL: URL) {
        self.id = id
        self.description = description
        self.location = location
        self.imageURL = imageURL
    }
}
