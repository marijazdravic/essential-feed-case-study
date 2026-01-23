//
//  SharedLocalizationTests.swift
//  EssentialFeedTests
//
//  Created by Marija Zdravic on 20.01.2026..
//
import XCTest
import EssentialFeed

class SharedLocalizationTests: XCTestCase {
    class SharedLocalizationTests: XCTestCase {
        func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
            let table = "Shared"
            let bundle = Bundle(for: LoadResourcePresenter<Any, DummyView>.self)

            assertLocalizedKeyAndValuesExist(in: bundle, table)
        }

        private class DummyView: ResourceView {
            func display(_ viewModel: Any) {}
        }
    }
}
