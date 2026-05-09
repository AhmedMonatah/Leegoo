//
//  FskeHomePresenter.swift
//  LeegooTests
//
//  Created by TaqieAllah on 10/05/2026.
//

import Foundation
@testable import Leegoo

final class FakeHomePresenter: HomePresenterProtocol {
    var itemsCount = 0

    func numberOfItems() -> Int { itemsCount }
    func item(at index: Int) -> Sport { Sport(title: "", imageName: "", endpoint: "") }
    func didSelectItem(at index: Int) {}
    func toggleThemeTapped() {}
}
