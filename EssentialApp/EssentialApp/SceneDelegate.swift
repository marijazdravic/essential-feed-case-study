//
//  SceneDelegate.swift
//  EssentialApp
//
//  Created by Marija Zdravic on 21.11.2025..
//

import os
import UIKit
import CoreData
import EssentialFeed
import Combine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    private lazy var scheduler: AnyDispatchQueueScheduler = {
        if let store = store as? CoreDataFeedStore {
            return .scheduler(for: store)
        }
        
        return DispatchQueue(
            label: "com.essentialdeveloper.infra.queue",
            qos: .userInitiated,
        ).eraseToAnyScheduler()
    }()
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var baseURL = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed")!
    
    private lazy var logger = Logger(subsystem: "com.essentialdeveloper.EssentialAppCaseStudy", category: "main")
    
    private lazy var store: FeedStore & FeedImageDataStore & StoreScheduler & Sendable = {
        do {
            return try CoreDataFeedStore(
                storeURL: NSPersistentContainer
                    .defaultDirectoryURL()
                    .appendingPathComponent("feed-store.sqlite"))
        } catch {
            assertionFailure("Failed to instantiate CoreData store with error: \(error.localizedDescription)")
            logger.fault("Failed to instantiate CoreData store with error: \(error.localizedDescription)")
            return InMemoryFeedStore()
        }
    }()
    
    private lazy var localFeedLoader: LocalFeedLoader = {
        LocalFeedLoader(store: store, currentDate: Date.init)
    }()
    
    private lazy var navigationController = UINavigationController(
        rootViewController: FeedUIComposer.feedComposedWith(
            feedLoader: makeRemoteFeedLoaderWithLocalFallback,
            imageLoader: loadLocalImageLoaderWithRemoteFallback,
            selection: showComments))
    
    convenience init(httpClient: HTTPClient, store: FeedStore & FeedImageDataStore & StoreScheduler & Sendable) {
        self.init()
        self.httpClient = httpClient
        self.store = store
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func configureWindow() {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        scheduler.schedule { [localFeedLoader, logger] in
            do {
                try localFeedLoader.validateCache()
            } catch {
                logger.error("Failed to validate cache with error: \(error.localizedDescription)")
            }
        }
    }
    
    private func showComments(for image: FeedImage) {
        let url = ImageCommentsEndpoint.get(image).url(baseURL: baseURL)
        let commentsController = CommentsUIComposer.commentsComposedWith(commentsLoader: makeRemoteCommentsLoader(url: url))
        navigationController.pushViewController(commentsController, animated: true)
    }
    
    private func loadRemoteFeedWithLocalFallback() async throws -> Paginated<FeedImage> {
        do {
            let feed = try await loadAndCacheRemoteFeed()
            return makeFirstPage(items: feed)
        } catch {
            let feed = try await loadLocalFeed()
            return makeFirstPage(items: feed)
        }
    }
    
    private func loadAndCacheRemoteFeed() async throws -> [FeedImage] {
        let feed = try await loadRemoteFeed()
        await store.schedule { [store] in
            let localFeedLoader = LocalFeedLoader(store: store, currentDate: Date.init)
            try? localFeedLoader.save(feed)
        }
        return feed
    }
    
    private func loadLocalFeed() async throws -> [FeedImage] {
        try await store.schedule { [store] in
            let localFeedLoader = LocalFeedLoader(store: store, currentDate: Date.init)
            return try localFeedLoader.load()
        }
    }
    
    private func loadRemoteFeed(after: FeedImage? = nil) async throws -> [FeedImage] {
        let url = FeedEndpoint.get(after: after).url(baseURL: baseURL)
        let (data, response) = try await httpClient.get(from: url)
        return try FeedItemsMapper.map(data, from: response)
    }
    
    private func loadMoreRemoteFeed(last: FeedImage?) async throws -> Paginated<FeedImage> {
        async let cachedItems = try await loadLocalFeed()
        async let newItems = try await loadRemoteFeed(after: last)
        
        let items = try await cachedItems + newItems
        
        await store.schedule { [store] in
            let localFeedLoader = LocalFeedLoader(store: store, currentDate: Date.init)
            try? localFeedLoader.save(items)
        }
        
        return try await makePage(items: items, last: newItems.last)
    }
    
    private func makeRemoteFeedLoaderWithLocalFallback() -> AnyPublisher<Paginated<FeedImage>, Error> {
        Deferred {
            Future { completion in
                Task.immediate {
                    do {
                        let feed = try await self.loadRemoteFeedWithLocalFallback()
                        completion(.success(feed))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func makeRemoteLoadMoreLoader(last: FeedImage?) -> AnyPublisher<Paginated<FeedImage>, Error> {
        Deferred {
            Future { completion in
                Task.immediate {
                    do {
                        let feed = try await self.loadMoreRemoteFeed(last: last)
                        completion(.success(feed))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func makeRemoteFeedLoader(after: FeedImage? = nil) -> AnyPublisher<[FeedImage], Error> {
        let url = FeedEndpoint.get(after: after).url(baseURL: baseURL)
        
        return httpClient
            .getPublisher(url: url)
            .tryMap(FeedItemsMapper.map)
            .eraseToAnyPublisher()
    }
    
    private func makeFirstPage(items: [FeedImage]) -> Paginated<FeedImage> {
        makePage(items: items, last: items.last)
    }
    
    private func makePage(items: [FeedImage], last: FeedImage?) -> Paginated<FeedImage> {
        Paginated(items: items, loadMorePublisher: last.map { last in { self.makeRemoteLoadMoreLoader(last: last) }
        })
    }
    
    private func makeRemoteCommentsLoader(url: URL) -> () -> AnyPublisher<[ImageComment], Error> {
        return { [httpClient] in
            return httpClient
                .getPublisher(url: url)
                .tryMap(ImageCommentsMapper.map)
                .eraseToAnyPublisher()
        }
    }
    
    func loadLocalImageLoaderWithRemoteFallback(url: URL) async throws -> Data {
        _ = LocalFeedImageDataLoader(store: store)
        
        do {
            return try await loadLocalImage(from: url)
        } catch {
            return try await loadAndCacheRemoteImage(from: url)
        }
    }
    
    func loadLocalImage(from url: URL) async throws -> Data {
        try await store.schedule { [store] in
            let localImageLoader = LocalFeedImageDataLoader(store: store)
            let imageData = try localImageLoader.loadImageData(from: url)
            return imageData
        }
    }
    
    func loadAndCacheRemoteImage(from url: URL) async throws -> Data {
        let (data, response) = try await httpClient.get(from: url)
        let imageData = try FeedImageDataMapper.map(data, from: response)
        await store.schedule { [store] in
            let localImageLoader = LocalFeedImageDataLoader(store: store)
            try? localImageLoader.save(imageData, for: url)
        }
        return imageData
    }
}

protocol StoreScheduler {
    @MainActor
    func schedule<T>(_ action: @Sendable @escaping () throws -> T) async rethrows -> T
}

extension CoreDataFeedStore: StoreScheduler {
    func schedule<T>(_ action: @escaping @Sendable () throws -> T) async rethrows -> T {
        if contextQueue == .main {
            return try action()
        } else {
          return try await perform(action)
        }
    }
}

extension InMemoryFeedStore: StoreScheduler {
    @MainActor
    func schedule<T>(_ action: @escaping @Sendable () throws -> T) async rethrows -> T {
        try action()
    }
}
