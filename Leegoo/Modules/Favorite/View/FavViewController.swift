//
//  FavViewController.swift
//  Leegoo
//
//  Created by TaqieAllah on 05/05/2026.
//

import UIKit

class FavViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var presenter: FavoritesPresenterProtocol!
    private let emptyView = NoDataView(title: "No Favorites Yet")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        presenter = FavoritesPresenter(view: self)
                
        tableView.delegate = self
        tableView.dataSource = self
                
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    
    
    private func updateEmptyState() {
            if presenter.numberOfFavorites == 0 {
                tableView.backgroundView = emptyView
                tableView.separatorStyle = .none
            } else {
                tableView.backgroundView = nil
                tableView.separatorStyle = .singleLine
            }
        }

}

extension FavViewController: FavoritesViewProtocol {
    
    func reloadData() {
        tableView.reloadData()
        updateEmptyState()
    }
    
    
    func navigateToLeagueDetails(league: League, sportName: String) {
        let storyboard = UIStoryboard(name: "LeaguesDetails", bundle: nil)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: "LeaguesDetailsViewController") as? LeaguesDetailsViewController else {
            return
        }
        
        vc.presenter = LeaguesDetailsPresenter(
            view: vc,
            sportName: sportName,
            league: league
        )
        
        navigationController?.pushViewController(vc, animated: true)
    }
    

}

extension FavViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfFavorites
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "leaguesCell", for: indexPath) as? LeaguesCell else {
            return UITableViewCell()
        }
        
        let league = presenter.favoriteLeague(at: indexPath.row)
        cell.configure(with: league)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectLeague(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            self?.presenter.deleteLeague(at: indexPath.row)
            completion(true)
        }
        
        deleteAction.backgroundColor = .systemRed
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
}

