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
    func insertItems(_ items: [FeedItem], timestamp: Date, completion: @escaping InsertCompletion)
}
