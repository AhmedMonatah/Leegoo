
import UIKit

struct OnboardingPage {
    let title: String
    let subtitle: String
    let imageName: String
    let accentColor: UIColor
}

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    

    var presenter: OnboardingPresenterProtocol!
    private var currentPage = 0
    private var isAnimating = false
    
    private let pages: [OnboardingPage] = [
        OnboardingPage(
            title: "TRACK EVERY GOAL",
            subtitle: "Stay updated with live football scores,\nleagues, and your favorite teams.",
            imageName: "o1",
            accentColor: UIColor(red: 0.40, green: 0.80, blue: 0.40, alpha: 1) // Adjusted for dark background
        ),
        OnboardingPage(
            title: "COURT-SIDE ACTION",
            subtitle: "Never miss a basket. Follow global\nbasketball leagues in real-time.",
            imageName: "o2",
            accentColor: UIColor(red: 1.0, green: 0.5, blue: 0.2, alpha: 1)
        ),
        OnboardingPage(
            title: "ACE EVERY MATCH",
            subtitle: "Grand Slam coverage and player stats\nright at your fingertips.",
            imageName: "o3",
            accentColor: UIColor(red: 1.0, green: 0.8, blue: 0.2, alpha: 1)
        )
    ]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRuntimeStyles()
        setupGestures()
        loadPage(0)
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
        
        // Modern arrow icon
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)
        if let arrow = UIImage(systemName: "arrow.right", withConfiguration: config) {
            nextButton.setImage(arrow, for: .normal)
            nextButton.tintColor = .white
            nextButton.semanticContentAttribute = .forceRightToLeft
            nextButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: -10)
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
    

    private func loadPage(_ index: Int) {
        let page = pages[index]
        

        let words = page.title.split(separator: " ")
        let result = NSMutableAttributedString()
        let norm: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "AvenirNext-Heavy", size: 34) ?? UIFont.systemFont(ofSize: 34, weight: .black),
            .foregroundColor: UIColor.white
        ]
        let accent: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "AvenirNext-Heavy", size: 34) ?? UIFont.systemFont(ofSize: 34, weight: .black),
            .foregroundColor: page.accentColor
        ]
        
        for (idx, word) in words.enumerated() {
            let attrs = (idx == words.count - 1) ? accent : norm
            result.append(NSAttributedString(string: String(word) + (idx == words.count - 1 ? "" : " "), attributes: attrs))
        }
        
        titleLabel.attributedText = result
        subtitleLabel.text = page.subtitle
        mainImageView.image = UIImage(named: page.imageName)
        pageControl.currentPage = index
        nextButton.setTitle(index == pages.count - 1 ? "Get Started" : "Continue", for: .normal)
        
        
        titleLabel.alpha = 0
        titleLabel.transform = CGAffineTransform(translationX: 50, y: 0)
        subtitleLabel.alpha = 0
        subtitleLabel.transform = CGAffineTransform(translationX: 30, y: 0)
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
    
    private func transitionToPage(_ index: Int) {
        guard !isAnimating else { return }
        isAnimating = true
        
        let newPage = pages[index]
        guard let snapshot = mainImageView.snapshotView(afterScreenUpdates: false) else {
            self.loadPage(index)
            self.animateIn()
            self.isAnimating = false
            return
        }
        
        snapshot.frame = mainImageView.frame
        view.insertSubview(snapshot, aboveSubview: mainImageView)
        
        // 2. Prepare new content
        mainImageView.image = UIImage(named: newPage.imageName)
        mainImageView.alpha = 0
        mainImageView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.titleLabel.alpha = 0
            self.subtitleLabel.alpha = 0
        }) { _ in
            self.loadPage(index)
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.85, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
                snapshot.alpha = 0
                snapshot.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                
                self.mainImageView.alpha = 1
                self.mainImageView.transform = .identity
                
                // Text animation triggered by loadPage's reset + animateIn
                self.animateIn()
            }) { _ in
                snapshot.removeFromSuperview()
                self.isAnimating = false
            }
        }
    }
    
    @IBAction func nextTapped(_ sender: UIButton) {
        if currentPage < pages.count - 1 {
            currentPage += 1
            transitionToPage(currentPage)
        } else {
            presenter.didFinishOnboarding()
        }
    }
    
    @IBAction func skipTapped(_ sender: UIButton) {
        presenter.didFinishOnboarding()
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
        guard currentPage < pages.count - 1 else { return }
        currentPage += 1
        transitionToPage(currentPage)
    }
    
    @objc private func swipedRight() {
        guard currentPage > 0 else { return }
        currentPage -= 1
        transitionToPage(currentPage)
    }
}

extension OnboardingViewController: OnboardingViewProtocol {
    func navigateToHome() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        guard let nav = sb.instantiateViewController(withIdentifier: "HomeNavigationController") as? UINavigationController,
              let home = nav.viewControllers.first as? HomeViewController else { return }
        home.presenter = HomePresenter(view: home)
        nav.modalTransitionStyle = .crossDissolve
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
}
