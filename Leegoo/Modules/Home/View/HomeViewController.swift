import UIKit

class HomeViewController: UIViewController ,HomeViewProtocol {
    
    var presenter: HomePresenterProtocol!
    
    @IBOutlet weak var sportsCollectionView: UICollectionView!
    
    @IBOutlet weak var themeToggleButton: UIButton!
    @IBOutlet weak var sportsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = HomePresenter(view: self)
        sportsCollectionView.delegate = self
        sportsCollectionView.dataSource = self
        
        applyTheme()
        ThemeManager.shared.applyGlobalAppearance(to: view.window)
        updateHomeHeaderTheme()
        NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: .themeDidChange, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        applyTheme()
        ThemeManager.shared.applyGlobalAppearance(to: view.window)
        updateHomeHeaderTheme()
        updateMoonIcon()
    }
    

    private func updateMoonIcon() {
        let moonImage = UIImage(systemName: ThemeManager.shared.isDarkTheme ? "moon.fill" : "moon")
        themeToggleButton.setImage(moonImage, for: .normal)
        themeToggleButton.tintColor = ThemeManager.shared.isDarkTheme ? .white : .systemBlue
    }
    
    private func updateHomeHeaderTheme() {
        let isDark = ThemeManager.shared.isDarkTheme
        sportsLabel?.textColor = isDark ? .white : .black
        
    }
    
    @objc private func toggleTheme() {
        guard let window = view.window else {
            ThemeManager.shared.toggleTheme()
            notifyAndRefresh()
            return
        }
        
        // Take a snapshot of the current state
        let snapshot = window.snapshotView(afterScreenUpdates: false)!
        window.addSubview(snapshot)
        
        // Apply all theme changes immediately
        ThemeManager.shared.toggleTheme()
        notifyAndRefresh()
        
        // Circular reveal animation from moon icon position
        let center = themeToggleButton.convert(themeToggleButton.center, to: window)
        
        // Calculate the radius needed to cover the entire screen
        let maxCorner = CGPoint(
            x: max(center.x, window.bounds.width - center.x),
            y: max(center.y, window.bounds.height - center.y)
        )
        let maxRadius = sqrt(maxCorner.x * maxCorner.x + maxCorner.y * maxCorner.y)
        
        // Create circular mask
        let startPath = UIBezierPath(ovalIn: CGRect(x: center.x, y: center.y, width: 0, height: 0))
        let endPath = UIBezierPath(ovalIn: CGRect(
            x: center.x - maxRadius,
            y: center.y - maxRadius,
            width: maxRadius * 2,
            height: maxRadius * 2
        ))
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = endPath.cgPath
        snapshot.layer.mask = maskLayer
        
        // Animate the mask to reveal the new theme underneath
        let anim = CABasicAnimation(keyPath: "path")
        anim.fromValue = endPath.cgPath
        anim.toValue = startPath.cgPath
        anim.duration = 0.6
        anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        anim.fillMode = .forwards
        anim.isRemovedOnCompletion = false
        
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            snapshot.removeFromSuperview()
        }
        maskLayer.add(anim, forKey: "circularReveal")
        CATransaction.commit()
    }
    
    private func notifyAndRefresh() {
        updateHomeHeaderTheme()
        NotificationCenter.default.post(name: .themeDidChange, object: nil)
    }
    
    @objc private func themeDidChange() {
        applyTheme()
        ThemeManager.shared.applyGlobalAppearance(to: view.window)
        updateHomeHeaderTheme()
        updateMoonIcon()
    }
    
    func navigateToLeagues(with sport: Sport) {
        let storyboard = UIStoryboard(name: "Home_Storyboard", bundle: nil)
           
        guard let leaguesVC = storyboard.instantiateViewController(withIdentifier: "LeaguesVC") as? LeaguesViewController else {
            return
        }
           
        let presenter = LeaguesPresenter(view: leaguesVC, title: sport.title, selectedSport: sport)
        leaguesVC.presenter = presenter
    
        navigationController?.pushViewController(leaguesVC, animated: true)
    }
       
    
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: HomeCell.identifier,
            for: indexPath
        ) as? HomeCell else {
            return UICollectionViewCell()
        }
        
        let item = presenter.item(at: indexPath.item)
        cell.configure(with: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectItem(at: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding: CGFloat = 12
        let spacing: CGFloat = 12

        let isLandscape = collectionView.bounds.width > collectionView.bounds.height
        let itemsPerRow: CGFloat = isLandscape ? 4 : 2

        let totalSpacing = (padding * 2) + ((itemsPerRow - 1) * spacing)
        let width = (collectionView.bounds.width - totalSpacing) / itemsPerRow
        let height = width * 1.5
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }
    
}
