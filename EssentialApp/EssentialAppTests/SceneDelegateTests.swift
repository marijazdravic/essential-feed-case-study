//
//  SceneDelegateTests.swift
//  EssentialAppTests
//
//  Created by Marija Zdravic on 30.11.2025..
//

import XCTest
@testable import EssentialApp
import EssentialFeediOS

class SceneDelegateTests: XCTestCase {
    
    func test_sceneWillConnectToSession_configuresRootViewController() {
        let sut = SceneDelegate()
        let windowScene = UIApplication.shared.connectedScenes.first as! UIWindowScene
        sut.window = UIWindow(windowScene: windowScene)
        
        sut.configureWindow()
        
        let root = sut.window?.rootViewController
        let rootNavigation = root as? UINavigationController
        let topController = rootNavigation?.topViewController
        
        XCTAssertNotNil(rootNavigation, "Expected a navigation controller as root got \(String(describing:root)) instead")
        XCTAssertTrue(topController is FeedViewController, "Expected a feed controller as top view controller, got \(String(describing: topController)) instead" )
    }
    
}
