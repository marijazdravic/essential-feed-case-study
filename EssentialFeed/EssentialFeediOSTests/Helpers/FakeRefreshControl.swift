//
//  FakeRefreshConroll.swift
//  EssentialFeediOSTests
//
//  Created by Marija Zdravic on 14.07.2025..
//

import Foundation
import UIKit

class FakeRefreshControl: UIRefreshControl {
    private var _isRefreshing = false
    
    override var isRefreshing: Bool { _isRefreshing }
    
    override func beginRefreshing() {
        _isRefreshing = true
    }
    
    override func endRefreshing() {
        _isRefreshing = false
    }
}

