//
//  ErrorView.swift
//  EssentialFeediOS
//
//  Created by Marija Zdravic on 28.10.2025..
//

import UIKit

public final class ErrorView: UIView {
    @IBOutlet private var label: UILabel!
    
    public var message: String? {
        get { return label.text }
        set { label.text = newValue }
    }
}
