//
//  LeaguesViewController.swift
//  Leegoo
//
//  Created by Ahmed Monatah on 28/04/2026.
//

import UIKit
import SkeletonView

final class LeaguesViewController: UIViewController, LeaguesViewProtocol {

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
        
        setupThemePickers()
        applyTheme()
        ThemeManager.shared.applyGlobalAppearance(to: view.window)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isSkeletonable = true
        tableView.theme_backgroundColor = AppTheme.tableBackgroundColor
        tableView.estimatedRowHeight = 85
        tableView.rowHeight = 85
        searchBar.delegate = self
        ThemeManager.shared.style(searchBar: searchBar)
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: .themeDidChange, object: nil)
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        applyTheme()
        ThemeManager.shared.applyGlobalAppearance(to: view.window)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupThemePickers() {
        titleLabel.theme_textColor = AppTheme.textColor
        subtitleLabel.theme_textColor = AppTheme.secondaryTextColor
        backBtn.theme_tintColor = AppTheme.accentColor
    }
    
    @objc private func themeDidChange() {
        ThemeManager.shared.style(searchBar: searchBar)
        applyTheme()
        ThemeManager.shared.applyGlobalAppearance(to: view.window)
        
        if isLoading {
            view.clearBackgroundsRecursively()
            tableView.showAnimatedGradientSkeleton()
        }
        tableView.reloadData()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
        
    func showLoading() {
        isLoading = true
        view.clearBackgroundsRecursively()
        tableView.showAnimatedGradientSkeleton(transition: .crossDissolve(0.25))
    }
        
    func hideLoading() {
        isLoading = false
        tableView.hideSkeleton()
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
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
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
        
        
        if isLoading {
            return cell
        }
        
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


extension LeaguesViewController: SkeletonTableViewDataSource {
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "leaguesCell"
    }
}

