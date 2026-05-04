//
//  FavPresenter.swift
//  Leegoo
//
//  Created by TaqieAllah on 05/05/2026.
//

import Foundation

class FavoritesPresenter: FavoritesPresenterProtocol {
    
    weak var view: FavoritesViewProtocol?
    private var favoriteLeagues: [FavoriteLeagueItem] = []
    
    init(view: FavoritesViewProtocol) {
        self.view = view
    }
    
    var numberOfFavorites: Int {
        favoriteLeagues.count
    }
    
    func viewDidLoad() {
        view?.setTitle("Favorites")
        loadFavorites()
    }
    
    func viewWillAppear() {
           loadFavorites()
       }
    
    func favoriteLeague(at index: Int) -> League {
        favoriteLeagues[index].league
    }
    
    func didSelectLeague(at index: Int) {
        let item = favoriteLeagues[index]
        view?.navigateToLeagueDetails(league: item.league, sportName: item.sportName)
    }
    
    func deleteLeague(at index: Int) {
        guard let leagueId = favoriteLeagues[index].league.leagueKey else { return }
        CoreDataManager.shared.deleteLeague(id: leagueId)
        favoriteLeagues.remove(at: index)
        view?.reloadData()
    }
    
    private func loadFavorites() {
        favoriteLeagues = CoreDataManager.shared.fetchFavorites()
        view?.reloadData()
    }
}

