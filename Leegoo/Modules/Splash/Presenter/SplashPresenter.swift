import Foundation

class SplashPresenter: SplashPresenterProtocol {
    
    weak var view: SplashViewProtocol?
    
    init(view: SplashViewProtocol) {
        self.view = view
    }
    
    func viewDidAppear() {
        // Delay for splash animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            self?.decideNextScreen()
        }
    }
    
    private func decideNextScreen() {
        let hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        if hasCompletedOnboarding {
            view?.navigateToHome()
        } else {
            view?.navigateToOnboarding()
        }
    }
}
