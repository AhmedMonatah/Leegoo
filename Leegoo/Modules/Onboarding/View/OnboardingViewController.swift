
import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    

    var presenter: OnboardingPresenterProtocol!
    private var isAnimating = false
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRuntimeStyles()
        setupGestures()
        presenter.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateIn()
    }
    

    private func setupRuntimeStyles() {
        nextButton.layer.cornerRadius = 28
        nextButton.layer.shadowColor = UIColor(red: 53/255, green: 69/255, blue: 255/255, alpha: 1).cgColor
        nextButton.layer.shadowOpacity = 0.3
        nextButton.layer.shadowOffset = CGSize(width: 0, height: 6)
        nextButton.layer.shadowRadius = 12
        
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)
        if let arrow = UIImage(systemName: "arrow.right", withConfiguration: config) {
            nextButton.setImage(arrow, for: .normal)
            nextButton.tintColor = .white
            nextButton.semanticContentAttribute = .forceRightToLeft
        }
        
        titleLabel.font = UIFont(name: "AvenirNext-Heavy", size: 34) ?? UIFont.systemFont(ofSize: 34, weight: .black)
        subtitleLabel.font = UIFont(name: "AvenirNext-Medium", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .medium)
        nextButton.titleLabel?.font = UIFont(name: "AvenirNext-Bold", size: 18) ?? UIFont.systemFont(ofSize: 18, weight: .bold)
    }
    
    private func setupGestures() {
        let left = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft))
        left.direction = .left
        view.addGestureRecognizer(left)
        let right = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight))
        right.direction = .right
        view.addGestureRecognizer(right)
    }
    

    private func animateIn() {
        UIView.animate(withDuration: 0.6, delay: 0.1, options: .curveEaseOut) {
            self.titleLabel.alpha = 1
            self.titleLabel.transform = .identity
        }
        UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut) {
            self.subtitleLabel.alpha = 1
            self.subtitleLabel.transform = .identity
        }
    }
    

    @IBAction func nextTapped(_ sender: UIButton) {
        presenter.nextTapped()
    }
    
    @IBAction func skipTapped(_ sender: UIButton) {
        presenter.skipTapped()
    }
    
    @IBAction func buttonDown(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) { self.nextButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95) }
    }
    
    @IBAction func buttonUp(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.3, options: .allowUserInteraction) {
            self.nextButton.transform = .identity
        }
    }
    
    @objc private func swipedLeft() {
        presenter.swipeLeft()
    }
    
    @objc private func swipedRight() {
        presenter.swipeRight()
    }
}


extension OnboardingViewController: OnboardingViewProtocol {
    
    func displayPage(_ viewModel: OnboardingPageViewModel) {
        if mainImageView.image == nil {
            // Initial load
            applyViewModel(viewModel)
            return
        }
        
        transitionToPage(viewModel)
    }
    
    private func applyViewModel(_ viewModel: OnboardingPageViewModel) {
        titleLabel.attributedText = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        mainImageView.image = UIImage(named: viewModel.imageName)
        pageControl.currentPage = viewModel.pageIndex
        pageControl.numberOfPages = viewModel.totalPages
        nextButton.setTitle(viewModel.buttonTitle, for: .normal)
        
        titleLabel.alpha = 0
        titleLabel.transform = CGAffineTransform(translationX: 50, y: 0)
        subtitleLabel.alpha = 0
        subtitleLabel.transform = CGAffineTransform(translationX: 30, y: 0)
    }
    
    private func transitionToPage(_ viewModel: OnboardingPageViewModel) {
        guard !isAnimating else { return }
        isAnimating = true
        
        guard let snapshot = mainImageView.snapshotView(afterScreenUpdates: false) else {
            applyViewModel(viewModel)
            animateIn()
            isAnimating = false
            return
        }
        
        snapshot.frame = mainImageView.frame
        view.insertSubview(snapshot, aboveSubview: mainImageView)
        
        mainImageView.image = UIImage(named: viewModel.imageName)
        mainImageView.alpha = 0
        mainImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.titleLabel.alpha = 0
            self.subtitleLabel.alpha = 0
        }) { _ in
            self.applyViewModel(viewModel)
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                snapshot.alpha = 0
                snapshot.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                
                self.mainImageView.alpha = 1
                self.mainImageView.transform = .identity
                
                self.animateIn()
            }) { _ in
                snapshot.removeFromSuperview()
                self.isAnimating = false
            }
        }
    }

    func navigateToHome() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let tabBar = sb.instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController else { return }
        if let nav = tabBar.viewControllers?.first as? UINavigationController,
            let home = nav.viewControllers.first as? HomeViewController {
            home.presenter = HomePresenter(view: home)
        }
        tabBar.modalTransitionStyle = .crossDissolve
        tabBar.modalPresentationStyle = .fullScreen
        
        if let window = view.window {
            window.rootViewController = tabBar
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil)
        } else {
            present(tabBar, animated: true)
        }
    }
}
