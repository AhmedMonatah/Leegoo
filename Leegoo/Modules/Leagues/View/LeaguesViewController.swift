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
    var presenter: LeaguesPresenterProtocol!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
                
        presenter.viewDidLoad()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
        
    func showLoading() {
        activityIndicator.startAnimating()
    }
        
    func hideLoading() {
        activityIndicator.stopAnimating()
    }
        
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
        
    func setTitle(_ title: String) {
        self.title = title
    }
    
    func navigateToDetails(league: League) {
        print("DEBUG: LeaguesViewController navigateToDetails called for \(league.leagueName ?? "Unknown")")
        let storyboard = UIStoryboard(name: "LeaguesDetails", bundle: nil)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: "LeaguesDetailsViewController") as? LeaguesDetailsViewController else {
            print("DEBUG: FAILED to instantiate LeaguesDetailsViewController")
            return
        }
        
        vc.presenter = LeaguesDetailsPresenter(
            view: vc,
            leagueId: "\(league.leagueKey ?? 0)",
            leagueName: league.leagueName ?? ""
        )
        print("DEBUG: Presenter assigned to vc (\(Unmanaged.passUnretained(vc).toOpaque()))")
        
        navigationController?.pushViewController(vc, animated: true)
    }
    

}


extension LeaguesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.numberOfLeagues
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "leaguesCell", for: indexPath) as? LeaguesCell else {
            return UITableViewCell()
        }
        
        let league = presenter.league(at: indexPath.row)
        cell.configure(with: league)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
