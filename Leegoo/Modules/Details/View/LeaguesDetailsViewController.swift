import UIKit

class LeaguesDetailsViewController: UIViewController {

    @IBOutlet weak var upcomingCollectionView: UICollectionView!
    @IBOutlet weak var latestCollectionView: UICollectionView!
    @IBOutlet weak var teamsCollectionView: UICollectionView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var presenter: LeaguesDetailsPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("DEBUG: LeaguesDetailsViewController (\(Unmanaged.passUnretained(self).toOpaque())) viewDidLoad")
        
        if presenter == nil {
            print("DEBUG: Presenter is NIL in viewDidLoad, using fallback")

            presenter = LeaguesDetailsPresenter(
                view: self,
                leagueId: "4328",
                leagueName: "Leegoo"
            )
        } else {
            print("DEBUG: Presenter is set in viewDidLoad")
        }
        
        presenter?.viewDidLoad()
    }
    
    @IBAction private func backButtonTapped(_ sender: Any) {
        print("DEBUG: Back button tapped")
        navigationController?.popViewController(animated: true)
    }

}

extension LeaguesDetailsViewController: LeaguesDetailsViewProtocol {
    func showLoading() {
        // Implement if needed
    }
    
    func hideLoading() {
        // Implement if needed
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showUpcomingEvents() {
        upcomingCollectionView.reloadData()
    }
    
    func showLatestEvents() {
        latestCollectionView.reloadData()
    }
    
    func showTeams() {
        teamsCollectionView.reloadData()
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}

extension LeaguesDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count: Int
        if collectionView == upcomingCollectionView {
            count = presenter?.upcomingCount ?? 0
            print("DEBUG: Upcoming count = \(count)")
        } else if collectionView == latestCollectionView {
            count = presenter?.latestCount ?? 0
            print("DEBUG: Latest count = \(count)")
        } else {
            count = presenter?.teamsCount ?? 0
            print("DEBUG: Teams count = \(count)")
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == upcomingCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpcomingCell", for: indexPath) as! UpcomingEventCell
            if let event = presenter?.upcomingEvent(at: indexPath.item) {
                cell.configure(with: event)
            }
            return cell
        } else if collectionView == latestCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LatestCell", for: indexPath) as! LatestEventCell
            if let event = presenter?.latestEvent(at: indexPath.item) {
                cell.configure(with: event)
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCell", for: indexPath) as! TeamCell
            if let team = presenter?.team(at: indexPath.item) {
                cell.configure(with: team)
            }
            return cell
        }
    }

}
