

import Foundation

protocol OnboardingViewProtocol: AnyObject {
    func navigateToHome()
}

protocol OnboardingPresenterProtocol: AnyObject {
    func didFinishOnboarding()
}
