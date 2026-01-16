//
//  RemoteImageCommentsLoader.swift
//  EssentialFeed
//
//  Created by Marija Zdravic on 15.01.2026..
//

import Foundation

public final class RemoteImageCommentsLoader {
    private let url: URL
    private let client: HTTPClient
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public typealias Result = Swift.Result<[ImageComment], Swift.Error>
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        _ = client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((data, response)):
                completion(RemoteImageCommentsLoader.map(data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try ImageCommentsMapper.map(data, from: response)
            return .success(items.toModels())
        } catch {
           return .failure(error)
        }
    }
}

private extension Array where Element == ImageComment {
    func toModels() -> [ImageComment] {
        return map { ImageComment(id: $0.id,
                                  message: $0.message,
                                  createdAt: $0.createdAt,
                                  username: $0.username)
        }
    }
}



