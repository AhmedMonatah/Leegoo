import UIKit

class LeaguesDetailsViewController: UIViewController {

 
    @IBOutlet weak var upcomingCollectionView: UICollectionView!
    @IBOutlet weak var latestCollectionView: UICollectionView!
    @IBOutlet weak var teamsCollectionView: UICollectionView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var latestSectionHeightConstraint: NSLayoutConstraint!
    
 
    var leagueId: String? = "4328"
    var leagueName: String? = "English Premier League"
    var isUpcomingLayoutSet = false
    private var upcomingEvents: [Event] = []
    private var latestEvents: [Event] = []
    private var teams: [Team] = []
    
    private let networkService = NetworkService.shared


    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViews()
        setupButtons()
        fetchData()
        updateTitle()
    }
    
    private func setupButtons() {
        backButton?.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    @objc private func backButtonTapped() {
        if navigationController != nil {
            navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    private func setupCollectionViews() {
        [upcomingCollectionView, latestCollectionView, teamsCollectionView].forEach {
            $0?.delegate = self
            $0?.dataSource = self
        }
    }
    
    private func updateTitle() {
        titleLabel.text = "Leegoo"
    }

    private func fetchData() {
        guard let leagueId = leagueId, let leagueName = leagueName else { return }
        
        networkService.fetchEvents(leagueId: leagueId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let events):
                    // Split events into upcoming and latest (mocking split for now)
                    self?.upcomingEvents = Array(events.prefix(5))
                    self?.latestEvents = Array(events.suffix(from: min(events.count, 5)))
                    self?.upcomingCollectionView.reloadData()
                    self?.latestCollectionView.reloadData()
                    self?.updateLatestSectionHeight()
                case .failure(let error):
                    print("Error fetching events: \(error)")
                 
                    let dummy = Event(idEvent: "0", strEvent: "Any Match", dateEvent: "2024-05-24", strTime: "16:00:00", intHomeScore: "0", intAwayScore: "0", idHomeTeam: "0", idAwayTeam: "0", strHomeTeam: "Home", strAwayTeam: "Away", strThumb: nil)
                    self?.upcomingEvents = Array(repeating: dummy, count: 3)
                    self?.latestEvents = Array(repeating: dummy, count: 5)
                    self?.upcomingCollectionView.reloadData()
                    self?.latestCollectionView.reloadData()
                    self?.updateLatestSectionHeight()
                }
            }
        }
        

        networkService.fetchTeams(leagueName: leagueName) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let teams):
                    self?.teams = teams
                    self?.teamsCollectionView.reloadData()
                case .failure(let error):
                    print("Error fetching teams: \(error)")
                    // Provide dummy data fallback
                    let dummyTeam = Team(idTeam: "0", strTeam: "Team", strTeamBadge: nil, strTeamLogo: nil, strDescriptionEN: nil, strStadium: nil, strCountry: nil, intFormedYear: nil, strWebsite: nil, strFacebook: nil, strTwitter: nil, strInstagram: nil)
                    self?.teams = Array(repeating: dummyTeam, count: 10)
                    self?.teamsCollectionView.reloadData()
                }
            }
        }
    }
    
    private func updateLatestSectionHeight() {
        let count = CGFloat(latestEvents.count)
        if count == 0 {
            latestSectionHeightConstraint.constant = 50
        } else {
            let itemHeight: CGFloat = 90
            let lineSpacing: CGFloat = 12
            let topOffset: CGFloat = 30 // Title height + spacing to collection view
            let contentHeight = (count * itemHeight) + ((count - 1) * lineSpacing)
            latestSectionHeightConstraint.constant = topOffset + contentHeight
        }
        view.layoutIfNeeded()
    }

}

extension LeaguesDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == upcomingCollectionView {
            return upcomingEvents.count
        } else if collectionView == latestCollectionView {
            return latestEvents.count
        } else {
            return teams.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == upcomingCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LD-cell-upcoming", for: indexPath) as! UpcomingEventCell
            cell.configure(with: upcomingEvents[indexPath.item])
            return cell
        } else if collectionView == latestCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LD-cell-latest", for: indexPath) as! LatestEventCell
            cell.configure(with: latestEvents[indexPath.item])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LD-cell-team", for: indexPath) as! TeamCell
            cell.configure(with: teams[indexPath.item])
            return cell
        }
    }

}
