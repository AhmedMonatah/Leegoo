//
//  LeaguesViewController.swift
//  Leegoo
//
//  Created by Ahmed Monatah on 28/04/2026.
//

import UIKit

protocol LeaguesViewProtocol: AnyObject {
    func reloadData()
    func showLoading()
    func hideLoading()
    func showError(_ message: String)
    func setTitle(_ title: String)
    func navigateToDetails(league: League)
}

class LeaguesViewController: UIViewController ,LeaguesViewProtocol {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    private var isLoading = false
    var presenter: LeaguesPresenterProtocol!
    
    
    private var customHeaderView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        applyTheme()
        ThemeManager.shared.applyGlobalAppearance(to: view.window)
        updateHeaderTheme()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: .themeDidChange, object: nil)
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        applyTheme()
        ThemeManager.shared.applyGlobalAppearance(to: view.window)
        updateHeaderTheme()
        tableView.reloadData()
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func updateHeaderTheme() {
        let isDark = ThemeManager.shared.isDarkTheme
        titleLabel?.textColor = ThemeManager.shared.textColor
        subtitleLabel?.textColor = ThemeManager.shared.secondaryTextColor
        backBtn?.tintColor = ThemeManager.shared.accentColor
    }
    
    @objc private func themeDidChange() {
        applyTheme()
        ThemeManager.shared.applyGlobalAppearance(to: view.window)
        updateHeaderTheme()
        
        // Force remove and re-add skeleton for loading cells
        if isLoading {
            for cell in tableView.visibleCells {
                cell.contentView.hideSkeleton()
                cell.contentView.showSkeleton()
            }
        }
        tableView.reloadData()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
        
    func showLoading() {
        isLoading = true
        tableView.reloadData()
    }
        
    func hideLoading() {
        isLoading = false
        tableView.reloadData()
    }
        
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
        
    func setTitle(_ title: String) {
        subtitleLabel.text = title
    }
    
    func navigateToDetails(league: League) {
        let storyboard = UIStoryboard(name: "LeaguesDetails", bundle: nil)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: "LeaguesDetailsViewController") as? LeaguesDetailsViewController else {
            return
        }
        
        vc.presenter = LeaguesDetailsPresenter(
            view: vc,
            sportName: presenter.selectedSport.endpoint,
            league: league
        )
        
        navigationController?.pushViewController(vc, animated: true)
    }
    

}


extension LeaguesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isLoading ? 10 : presenter.numberOfLeagues
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "leaguesCell", for: indexPath) as? LeaguesCell else {
            return UITableViewCell()
        }
        
        cell.applyTheme()
        ThemeManager.shared.applyGlobalAppearance(to: view.window)
        
        if isLoading {
            cell.leagueName.text = "                   "
            cell.leagueLogo.image = nil
            cell.contentView.showSkeleton()
            return cell
        }
        
        cell.contentView.hideSkeleton()
        let league = presenter.league(at: indexPath.row)
        cell.configure(with: league)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !isLoading else { return }
        guard NetworkMonitor.shared.isConnected else {
            showNoInternetAlert()
            return
        }
        presenter.didSelectLeague(at: indexPath.row)
    }
    
    
}


extension LeaguesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.searchLeagues(with: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
