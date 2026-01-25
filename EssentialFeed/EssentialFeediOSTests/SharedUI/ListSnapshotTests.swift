//
//  ListSnapshotTests.swift
//  EssentialFeediOSTests
//
//  Created by Marija Zdravic on 24.01.2026..
//

import XCTest
import EssentialFeediOS
import EssentialFeed

class ListSnapshotTests: XCTestCase {
    
    func test_emptyList() {
        let sut = makeSUT()
        
        sut.display(emptyList())
        
        assert(snapshot: sut.snapshot(for: .iPhone(style: .light)), named: "EMPTY_List_light")
        assert(snapshot: sut.snapshot(for: .iPhone(style: .dark)), named: "EMPTY_List_dark")
    }
    
    func test_listWithErrorMessage() {
        let sut = makeSUT()
        
        sut.display(.error(message: "This is a\nmulti-line\nerror message"))
        
        assert(snapshot: sut.snapshot(for: .iPhone(style: .light)), named: "LIST_WITH_ERROR_MESSAGE_light")
        assert(snapshot: sut.snapshot(for: .iPhone(style: .dark)), named: "LIST_WITH_ERROR_MESSAGE_dark")
        assert(snapshot: sut.snapshot(for: .iPhone(style: .light)), named: "LIST_WITH_ERROR_MESSAGE_dark")
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> ListViewController {
        let controller = ListViewController()
        controller.loadViewIfNeeded()
        controller.tableView.separatorStyle = .none
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator = false
        return controller
    }
    
    private func emptyList() -> [CellController] {
        return []
    }
}
