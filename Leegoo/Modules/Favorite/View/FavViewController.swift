//
//  FavViewController.swift
//  Leegoo
//
//  Created by TaqieAllah on 05/05/2026.
//

import UIKit

class FavViewController: UIViewController {

    @IBOutlet weak var favTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var presenter: FavoritesPresenterProtocol!
    private let emptyView = NoDataView(title: "No Favorites Yet")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = FavoritesPresenter(view: self)
        tableView.delegate = self
        tableView.dataSource = self
        presenter.viewDidLoad()
        applyTheme()
        ThemeManager.shared.applyGlobalAppearance(to: view.window)
        updateHeaderTheme()
        
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: .themeDidChange, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        applyTheme()
        ThemeManager.shared.applyGlobalAppearance(to: view.window)
        updateHeaderTheme()
        presenter.viewWillAppear()
        tableView.reloadData()
    }
    
    @objc private func themeDidChange() {
        applyTheme()
        ThemeManager.shared.applyGlobalAppearance(to: view.window)
        updateHeaderTheme()
        tableView.reloadData()
    }
    
    private func updateHeaderTheme() {
        let isDark = ThemeManager.shared.isDarkTheme
        favTitleLabel?.textColor = isDark ? .white : .black
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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
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
        
        cell.applyTheme()
        ThemeManager.shared.applyGlobalAppearance(to: view.window)
        
        let league = presenter.favoriteLeague(at: indexPath.row)
        cell.configure(with: league)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard NetworkMonitor.shared.isConnected else {
            showNoInternetAlert()
            return
        }
        
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

