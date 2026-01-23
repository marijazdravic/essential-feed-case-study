//
//  ImageCommentsLocalizationTests.swift
//  EssentialFeedTests
//
//  Created by Marija Zdravic on 23.01.2026..
//

import XCTest
import EssentialFeed

final class ImageCommentsLocalizationTests: XCTestCase {
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "ImageComments"
        let bundle = Bundle(for: ImageCommentsPresenter.self)

        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }
}

