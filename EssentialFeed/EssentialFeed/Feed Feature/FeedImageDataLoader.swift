//
//  FeedImageDataLoader.swift
//  EssentialFeediOS
//
//  Created by Marija Zdravic on 11.07.2025..
//

import Foundation

public protocol FeedImageDataLoader {
    typealias Result = Swift.Result<Data, Error>
    
    func loadImageData(from url: URL) throws -> Data
}
