//
//  UIControl+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Marija Zdravic on 14.07.2025..
//

import UIKit

extension UIControl {
    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
