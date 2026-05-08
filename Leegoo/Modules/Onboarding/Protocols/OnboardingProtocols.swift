

import Foundation

struct OnboardingPageViewModel {
    let title: NSAttributedString
    let subtitle: String
    let imageName: String
    let buttonTitle: String
    let pageIndex: Int
    let totalPages: Int
}

protocol OnboardingViewProtocol: AnyObject {
    func displayPage(_ viewModel: OnboardingPageViewModel)
    func navigateToHome()
}

protocol OnboardingPresenterProtocol: AnyObject {
    func viewDidLoad()
    func nextTapped()
    func skipTapped()
    func swipeLeft()
    func swipeRight()
}
