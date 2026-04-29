
import Foundation

class OnboardingPresenter: OnboardingPresenterProtocol {
    
    weak var view: OnboardingViewProtocol?
    
    init(view: OnboardingViewProtocol) {
        self.view = view
    }
    
    func didFinishOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        view?.navigateToHome()
    }
}
