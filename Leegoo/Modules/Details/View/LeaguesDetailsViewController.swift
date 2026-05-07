import UIKit
import SDWebImage

class LeaguesDetailsViewController: UIViewController {

    @IBOutlet weak var upcomingCollectionView: UICollectionView!
    @IBOutlet weak var latestCollectionView: UICollectionView!
    @IBOutlet weak var teamsCollectionView: UICollectionView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    private let upcomingEmptyView = NoDataView(title: "No Data found")
    private let latestEmptyView = NoDataView(title: "No Data found")
    private let teamsEmptyView = NoDataView(title: "No Data found")
    
    
    private var isLoading = false
    var presenter: LeaguesDetailsPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoriteButton.imageView?.contentMode = .scaleAspectFit
        setupUpcomingCollectionView()
        setupLatestCollectionView()
        setupTeamsCollectionView()
        
        upcomingCollectionView.delegate = self
        upcomingCollectionView.dataSource = self

        latestCollectionView.delegate = self
        latestCollectionView.dataSource = self

        teamsCollectionView.delegate = self
        teamsCollectionView.dataSource = self

        // Apply theme AFTER all views are configured
        applyTheme()
        ThemeManager.shared.applyGlobalAppearance(to: view.window)
        updateSpecificTheme()
        titleLabel?.numberOfLines = 2
        titleLabel?.lineBreakMode = .byWordWrapping

        presenter?.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: .themeDidChange, object: nil)
    }
    
    @objc private func themeDidChange() {
        applyTheme()
        ThemeManager.shared.applyGlobalAppearance(to: view.window)
        updateSpecificTheme()
        
        // Re-create shimmer for loading cells
        if isLoading {
            for cell in upcomingCollectionView.visibleCells {
                cell.contentView.hideSkeleton()
                cell.contentView.showSkeleton()
            }
            for cell in latestCollectionView.visibleCells {
                cell.contentView.hideSkeleton()
                cell.contentView.showSkeleton()
            }
            for cell in teamsCollectionView.visibleCells {
                cell.contentView.hideSkeleton()
                cell.contentView.showSkeleton()
            }
        }
        
        upcomingCollectionView.reloadData()
        latestCollectionView.reloadData()
        teamsCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyTheme()
        ThemeManager.shared.applyGlobalAppearance(to: view.window)
        updateSpecificTheme()
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        // Reload to pick up latest theme
        upcomingCollectionView.reloadData()
        latestCollectionView.reloadData()
        teamsCollectionView.reloadData()
    }
    
    private func updateSpecificTheme() {
        titleLabel?.textColor = ThemeManager.shared.textColor
        titleLabel?.numberOfLines = 2
        titleLabel?.lineBreakMode = .byWordWrapping
        
        updateFavoriteButton(isFavorite: presenter?.isFavorite() ?? false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @IBAction func backAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addFavorite(_ sender: Any) {
        presenter?.toggleFavorite()
    }
    
    private func setupUpcomingCollectionView() {
        upcomingCollectionView.decelerationRate = .fast
        upcomingCollectionView.isPagingEnabled = false
        
        if let layout = upcomingCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 20
            layout.sectionInset = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32)
            layout.itemSize = CGSize(width: view.frame.width - 64, height: 220)
        }
    }
    
    private func setupLatestCollectionView() {
        if let layout = latestCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 12
            layout.itemSize = CGSize(width: view.frame.width - 40, height: 130)
        }
    }
    
    private func setupTeamsCollectionView() {
        if let layout = teamsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 16
            layout.minimumInteritemSpacing = 16
            layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
            layout.itemSize = CGSize(width: 90, height: 125)
        }
    }
    
}

extension LeaguesDetailsViewController: LeaguesDetailsViewProtocol {
    func showLoading() {
        isLoading = true
        upcomingCollectionView.reloadData()
        latestCollectionView.reloadData()
        teamsCollectionView.reloadData()
    }
    
    func hideLoading() {
        isLoading = false
        upcomingCollectionView.reloadData()
        latestCollectionView.reloadData()
        teamsCollectionView.reloadData()
        
        updateEmptyState(for: upcomingCollectionView, count: presenter?.upcomingCount ?? 0)
        updateEmptyState(for: latestCollectionView, count: presenter?.latestCount ?? 0)
        updateEmptyState(for: teamsCollectionView, count: presenter?.teamsCount ?? 0)
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showUpcomingEvents() {
        upcomingCollectionView.reloadData()
        updateEmptyState(for: upcomingCollectionView, count: presenter?.upcomingCount ?? 0)
    }
    
    func showLatestEvents() {
        latestCollectionView.reloadData()
        updateEmptyState(for: latestCollectionView, count: presenter?.latestCount ?? 0)
    }
    
    func showTeams() {
        teamsCollectionView.reloadData()
        updateEmptyState(for: teamsCollectionView, count: presenter?.teamsCount ?? 0)
    }
    
    private func updateEmptyState(for collectionView: UICollectionView, count: Int) {
        if isLoading {
            collectionView.backgroundView = nil
            return
        }
        if count == 0 {
            if collectionView == upcomingCollectionView {
                collectionView.backgroundView = upcomingEmptyView
            } else if collectionView == latestCollectionView {
                collectionView.backgroundView = latestEmptyView
            } else {
                collectionView.backgroundView = teamsEmptyView
            }
        } else {
            collectionView.backgroundView = nil
        }
    }

    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func navigateToTeamDetails(teamId: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "SquadViewController") as? SquadViewController else { return }
        
        vc.presenter = TeamDetailsPresenter(
            view: vc,
            sportName: presenter?.sport ?? "football",
            teamId: teamId
        )
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func updateFavoriteButton(isFavorite: Bool) {
        let imageName = isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
        let isDark = ThemeManager.shared.isDarkTheme
        favoriteButton.tintColor = isFavorite ? .systemRed : (isDark ? .white : .systemGray)
    }
}

extension LeaguesDetailsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !isLoading else { return }
        guard NetworkMonitor.shared.isConnected else {
            showNoInternetAlert()
            return
        }
        if collectionView == teamsCollectionView {
            presenter?.didSelectTeam(at: indexPath.item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isLoading { return 5 }
        let count: Int
        if collectionView == upcomingCollectionView {
                        count = presenter?.upcomingCount ?? 0
        } else if collectionView == latestCollectionView {
                        count = presenter?.latestCount ?? 0
        } else {
                        count = presenter?.teamsCount ?? 0
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == upcomingCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpcomingCell", for: indexPath) as! UpcomingEventCell
            cell.applyTheme()
        ThemeManager.shared.applyGlobalAppearance(to: view.window)
            if isLoading {
                cell.contentView.showSkeleton()
            } else {
                cell.contentView.hideSkeleton()
                if let event = presenter?.upcomingEvent(at: indexPath.item) {
                    cell.configure(with: event)
                }
            }
            return cell
        } else if collectionView == latestCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LatestCell", for: indexPath) as! LatestEventCell
            cell.applyTheme()
        ThemeManager.shared.applyGlobalAppearance(to: view.window)
            if isLoading {
                cell.contentView.showSkeleton()
            } else {
                cell.contentView.hideSkeleton()
                if let event = presenter?.latestEvent(at: indexPath.item) {
                    cell.configure(with: event)
                }
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCell", for: indexPath) as! TeamCell
            cell.applyTheme()
        ThemeManager.shared.applyGlobalAppearance(to: view.window)
            if isLoading {
                cell.contentView.showSkeleton()
            } else {
                cell.contentView.hideSkeleton()
                if let team = presenter?.team(at: indexPath.item) {
                    cell.configure(with: team)
                }
            }
            return cell
        }
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard scrollView == upcomingCollectionView else { return }
        
        let layout = upcomingCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        
        var offset = targetContentOffset.pointee
        let index = offset.x / cellWidthIncludingSpacing
        let roundedIndex = round(index)
        
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing, y: 0)
        
        targetContentOffset.pointee = offset
    }
}
