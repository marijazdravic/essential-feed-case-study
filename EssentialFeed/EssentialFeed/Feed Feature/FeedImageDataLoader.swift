//
//  FeedImageDataLoader.swift
//  EssentialFeediOS
//
//  Created by Marija Zdravic on 11.07.2025..
//

import Foundation

public protocol FeedImageDataLoader {
    func loadImageData(from url: URL) throws -> Data
}
