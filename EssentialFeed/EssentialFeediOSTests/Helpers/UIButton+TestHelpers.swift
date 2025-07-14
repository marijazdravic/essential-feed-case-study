//
//  UIButton+TestHelpers.swift
//  EssentialFeediOSTests
//
//  Created by Marija Zdravic on 14.07.2025..
//

import Foundation
import UIKit

extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}

