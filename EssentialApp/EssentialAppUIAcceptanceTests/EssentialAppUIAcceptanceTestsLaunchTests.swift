//
//  EssentialAppUIAcceptanceTestsLaunchTests.swift
//  EssentialAppUIAcceptanceTests
//
//  Created by Marija Zdravic on 27.11.2025..
//

import XCTest

final class EssentialAppUIAcceptanceTestsLaunchTests: XCTestCase {
    
    func test_onLaunch_displaysRemoteFeedWhenCustomerHasConnectivity() {
        let app = XCUIApplication()
        
        app.launch()
        
        XCTAssertEqual(app.cells.count, 22)
        XCTAssertEqual(app.cells.firstMatch.images.count, 1)
    }
}
