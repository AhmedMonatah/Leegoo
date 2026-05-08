import Foundation

protocol SplashViewProtocol: AnyObject {
    func navigateToOnboarding()
    func navigateToHome()
}

protocol SplashPresenterProtocol: AnyObject {
    func viewDidAppear()
}
