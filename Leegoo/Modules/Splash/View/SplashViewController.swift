import UIKit

class SplashViewController: UIViewController {

    private let gradientLayer = CAGradientLayer()
    
    private let ballImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "SoccerBall")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .equalSpacing
        sv.spacing = 2
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let loadingDotsContainer: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 8
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private var characterLabels: [UILabel] = []
    private var dots: [UIView] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimations()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }

 
    private func setupUI() {
        view.backgroundColor = .white
        

        gradientLayer.colors = [
            UIColor(red: 0.208, green: 0.271, blue: 1.0, alpha: 1.0).cgColor, // #3545FF
            UIColor(red: 0.102, green: 0.169, blue: 0.620, alpha: 1.0).cgColor  // #1a2b9e
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
        

        view.addSubview(ballImageView)
        
 
        view.addSubview(titleStackView)
        setupTitleCharacters()
        

        view.addSubview(loadingDotsContainer)
        setupLoadingDots()
        
        NSLayoutConstraint.activate([
            ballImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            ballImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            ballImageView.widthAnchor.constraint(equalToConstant: 80),
            ballImageView.heightAnchor.constraint(equalToConstant: 80),
            
            titleStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleStackView.topAnchor.constraint(equalTo: ballImageView.bottomAnchor, constant: 32),
            
            loadingDotsContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingDotsContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -48)
        ])
    }
    
    private func setupTitleCharacters() {
        let text = "Leegoo"
        for char in text {
            let label = UILabel()
            label.text = String(char)
            label.font = UIFont.systemFont(ofSize: 48, weight: .black)
            label.textColor = .white
            label.alpha = 0
            label.transform = CGAffineTransform(translationX: 0, y: 20).scaledBy(x: 0.8, y: 0.8)
            titleStackView.addArrangedSubview(label)
            characterLabels.append(label)
        }
    }
    
    private func setupLoadingDots() {
        for _ in 0..<3 {
            let dot = UIView()
            dot.backgroundColor = UIColor.white.withAlphaComponent(0.7)
            dot.layer.cornerRadius = 4
            dot.translatesAutoresizingMaskIntoConstraints = false
            dot.widthAnchor.constraint(equalToConstant: 8).isActive = true
            dot.heightAnchor.constraint(equalToConstant: 8).isActive = true
            loadingDotsContainer.addArrangedSubview(dot)
            dots.append(dot)
        }
    }


    private func startAnimations() {
        rotateIcon()
        animateCharacters()
        animateLoadingDots()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.goToHome()
        }
    }
    
    private func rotateIcon() {
        let rotation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = NSNumber(value: Double.pi * 2)
        rotation.duration = 2.0
        rotation.isCumulative = true
        rotation.repeatCount = .infinity
        ballImageView.layer.add(rotation, forKey: "rotationAnimation")
    }
    
    private func animateCharacters() {
        for (index, label) in characterLabels.enumerated() {
            // Initial state for extra "pop"
            label.transform = CGAffineTransform(scaleX: 0.5, y: 0.5).rotated(by: -0.2)
            
            UIView.animate(withDuration: 0.8, 
                           delay: Double(index) * 0.12, 
                           usingSpringWithDamping: 0.6, 
                           initialSpringVelocity: 0.8, 
                           options: .curveEaseOut, 
                           animations: {
                label.alpha = 1
                label.transform = .identity
            }, completion: nil)
        }
    }
    
    private func animateLoadingDots() {
        for (index, dot) in dots.enumerated() {
            UIView.animate(withDuration: 0.5, delay: Double(index) * 0.2, options: [.repeat, .autoreverse, .curveEaseInOut], animations: {
                dot.transform = CGAffineTransform(translationX: 0, y: -8)
            }, completion: nil)
        }
    }

    
    private func goToHome() {
        let hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        
        let destinationVC: UIViewController
        if !hasCompletedOnboarding {
            let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
            guard let onboardingVC = storyboard.instantiateViewController(withIdentifier: "OnboardingViewController") as? OnboardingViewController else { return }
            let onboardingPresenter = OnboardingPresenter(view: onboardingVC)
            onboardingVC.presenter = onboardingPresenter
            destinationVC = UINavigationController(rootViewController: onboardingVC)
        } else {
            let storyboard = UIStoryboard(name: "Home_Storyboard", bundle: nil)
                guard let tabBarVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController else { return }
                if let navVC = tabBarVC.viewControllers?.first as? UINavigationController,
                let homeVC = navVC.viewControllers.first as? HomeViewController {
                    let presenter = HomePresenter(view: homeVC)
                    homeVC.presenter = presenter
                }
            destinationVC = tabBarVC
        }
        
        destinationVC.modalTransitionStyle = .crossDissolve
        destinationVC.modalPresentationStyle = .fullScreen
        present(destinationVC, animated: true)
    }
}

