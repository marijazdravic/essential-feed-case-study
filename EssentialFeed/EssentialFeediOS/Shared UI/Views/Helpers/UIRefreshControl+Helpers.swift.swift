//
//  UIRefreshControl+Helpers.swift.swift
//  EssentialFeediOS
//
//  Created by Marija Zdravic on 02.11.2025..
//

import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
