import UIKit
import SwiftTheme
import SDWebImage
import SkeletonView

final class LeaguesDetailsViewController: UIViewController {

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

        upcomingCollectionView.isSkeletonable = true
        latestCollectionView.isSkeletonable = true
        teamsCollectionView.isSkeletonable = true

        titleLabel?.numberOfLines = 2
        titleLabel?.lineBreakMode = .byWordWrapping

        setupThemePickers()
        applyTheme()
        ThemeManager.shared.applyGlobalAppearance(to: view.window)
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: .themeDidChange, object: nil)

        presenter?.viewDidLoad()
    }
    
    @objc private func themeDidChange() {
        applyTheme()
        ThemeManager.shared.applyGlobalAppearance(to: view.window)
        updateFavoriteButton(isFavorite: presenter?.isFavorite() ?? false)
        
        if isLoading {
            view.clearBackgroundsRecursively()
            upcomingCollectionView.showAnimatedGradientSkeleton()
            latestCollectionView.showAnimatedGradientSkeleton()
            teamsCollectionView.showAnimatedGradientSkeleton()
        }
        
        upcomingCollectionView.reloadData()
        latestCollectionView.reloadData()
        teamsCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyTheme()
        ThemeManager.shared.applyGlobalAppearance(to: view.window)
        setupThemePickers()
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        upcomingCollectionView.reloadData()
        latestCollectionView.reloadData()
        teamsCollectionView.reloadData()
    }
    
    private func setupThemePickers() {
        titleLabel.theme_textColor = AppTheme.textColor
        upcomingCollectionView.theme_backgroundColor = AppTheme.tableBackgroundColor
        latestCollectionView.theme_backgroundColor = AppTheme.tableBackgroundColor
        teamsCollectionView.theme_backgroundColor = AppTheme.tableBackgroundColor
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
        view.clearBackgroundsRecursively()
        upcomingCollectionView.showAnimatedGradientSkeleton(transition: .crossDissolve(0.25))
        latestCollectionView.showAnimatedGradientSkeleton(transition: .crossDissolve(0.25))
        teamsCollectionView.showAnimatedGradientSkeleton(transition: .crossDissolve(0.25))
    }
    
    func hideLoading() {
        isLoading = false
        upcomingCollectionView.hideSkeleton()
        latestCollectionView.hideSkeleton()
        teamsCollectionView.hideSkeleton()
        
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
        if isFavorite {
            favoriteButton.theme_tintColor = ThemeColorPicker(colors: "#FF3B30", "#FF453A")
        } else {
            favoriteButton.theme_tintColor = ThemeColorPicker(colors: "#8E8E93", "#FFFFFF")
        }
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
        let identifier = collectionView == upcomingCollectionView ? "UpcomingCell" : (collectionView == latestCollectionView ? "LatestCell" : "TeamCell")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        
        if isLoading {
            return cell
        }
        
        if collectionView == upcomingCollectionView {
            if let cell = cell as? UpcomingEventCell, let event = presenter?.upcomingEvent(at: indexPath.item) {
                cell.configure(with: event)
            }
        } else if collectionView == latestCollectionView {
            if let cell = cell as? LatestEventCell, let event = presenter?.latestEvent(at: indexPath.item) {
                cell.configure(with: event)
            }
        } else {
            if let cell = cell as? TeamCell, let team = presenter?.team(at: indexPath.item) {
                cell.configure(with: team)
            }
        }
        return cell
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

extension LeaguesDetailsViewController: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        if skeletonView == upcomingCollectionView {
            return "UpcomingCell"
        } else if skeletonView == latestCollectionView {
            return "LatestCell"
        } else {
            return "TeamCell"
        }
    }
}
