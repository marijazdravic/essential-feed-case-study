//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Marija Zdravic on 20.05.2025..
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
