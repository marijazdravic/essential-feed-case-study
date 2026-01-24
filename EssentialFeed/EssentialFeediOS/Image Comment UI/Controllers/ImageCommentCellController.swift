//
//  ImageCellController.swift
//  EssentialFeediOS
//
//  Created by Marija Zdravic on 24.01.2026..
//

import UIKit
import EssentialFeed

public class ImageCommentCellController: CellController {
    private let model: ImageCommentViewModel
    
    public init(model: ImageCommentViewModel) {
        self.model = model
    }
    public func view(in tableView: UITableView) -> UITableViewCell {
        let cell: ImageCommentCell = tableView.dequeueReusableCell()
        cell.messageLabel.text = model.message
        cell.dateLabel.text = model.date
        cell.userNameLabel.text = model.username
        
        return cell
    }
    
    public func preload() {

    }
    
    public func cancelLoad() {

    }
    
    
}
