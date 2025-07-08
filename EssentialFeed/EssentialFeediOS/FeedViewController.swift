//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by Marija Zdravic on 03.07.2025..
//

import Foundation
import EssentialFeed
import UIKit

public final class FeedViewController: UITableViewController {
    private var loader: FeedLoader?
    private var tableModel = [FeedImage]()
    private var onViewIsAppearing: ((FeedViewController) -> Void)?
    
    public convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        
        onViewIsAppearing = { vc in
            vc.refresh()
            vc.onViewIsAppearing = nil
        }
        
        load()
    }
    
    public override func viewIsAppearing(_ animated: Bool) {
        onViewIsAppearing?(self)
    }
    
    @objc private func load() {
        refresh()
        loader?.load { [weak self] result in
            switch result {
            case .success:
                self?.tableModel = (try? result.get()) ?? []
                self?.tableView.reloadData()
                self?.refreshControl?.endRefreshing()
            case .failure:
                break
            }
        }
    }
    
    @objc private func refresh() {
        refreshControl?.beginRefreshing()
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = tableModel[indexPath.row]
        let cell = FeedImageCell()
        cell.locationContainer.isHidden = cellModel.location == nil
        cell.locationLabel.text = cellModel.location
        cell.descriptionLabel.text = cellModel.description
        return cell
    }
}
