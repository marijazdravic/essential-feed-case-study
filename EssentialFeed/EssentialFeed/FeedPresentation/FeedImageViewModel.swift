//
//  FeedImageViewModel.swift
//  EssentialFeed
//
//  Created by Marija Zdravic on 06.11.2025..
//

import Foundation

public struct FeedImageViewModel {
    public let description: String?
    public let location: String?
    
    public var hasLocation: Bool {
        return location != nil
    }
}

