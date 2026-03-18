//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Marija Zdravic on 20.05.2025..
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL) async throws -> (Data, HTTPURLResponse)
}
