//
//  HomeVCTests.swift
//  LeegooTests
//
//  Created by TaqieAllah on 10/05/2026.
//

import XCTest
@testable import Leegoo

final class HomeVCTests: XCTestCase {

    var vc: HomeViewController!
    var presenter: FakeHomePresenter!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        vc = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
        presenter = FakeHomePresenter()
        vc.presenter = presenter
        vc.loadViewIfNeeded()
    }

    func test_outletsConnected() {
        XCTAssertNotNil(vc.sportsCollectionView)
        XCTAssertNotNil(vc.themeToggleButton)
        XCTAssertNotNil(vc.sportsLabel)
    }

    func test_numberOfItems_comesFromPresenter() {
        presenter.itemsCount = 4
        XCTAssertEqual(vc.collectionView(vc.sportsCollectionView, numberOfItemsInSection: 0), 4)
    }

}
