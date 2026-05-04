//
//  FavProtocols.swift
//  Leegoo
//
//  Created by TaqieAllah on 05/05/2026.
//

import Foundation

protocol FavoritesViewProtocol: AnyObject {
    func reloadData()
    func setTitle(_ title: String)
    func navigateToLeagueDetails(league: League,sportName: String)
}

protocol FavoritesPresenterProtocol: AnyObject {
    var numberOfFavorites: Int { get }

    func viewDidLoad()
    func favoriteLeague(at index: Int) -> League
    func deleteLeague(at index: Int)
    func didSelectLeague(at index: Int)
}
