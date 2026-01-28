//
//  UITableView+Dequeueing.swift.swift
//  EssentialFeediOS
//
//  Created by Marija Zdravic on 15.07.2025..
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}


