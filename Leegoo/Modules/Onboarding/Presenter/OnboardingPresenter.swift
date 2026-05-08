
import Foundation

import UIKit

class OnboardingPresenter: OnboardingPresenterProtocol {
    
    weak var view: OnboardingViewProtocol?
    private var currentPage = 0
    
    private struct OnboardingData {
        let title: String
        let subtitle: String
        let imageName: String
        let accentColor: UIColor
    }
    
    private let pages: [OnboardingData] = [
        OnboardingData(
            title: "TRACK EVERY GOAL",
            subtitle: "Stay updated with live football scores,\nleagues, and your favorite teams.",
            imageName: "o1",
            accentColor: UIColor(red: 0.40, green: 0.80, blue: 0.40, alpha: 1)
        ),
        OnboardingData(
            title: "COURT-SIDE ACTION",
            subtitle: "Never miss a basket. Follow global\nbasketball leagues in real-time.",
            imageName: "o2",
            accentColor: UIColor(red: 1.0, green: 0.5, blue: 0.2, alpha: 1)
        ),
        OnboardingData(
            title: "ACE EVERY MATCH",
            subtitle: "Grand Slam coverage and player stats\nright at your fingertips.",
            imageName: "o3",
            accentColor: UIColor(red: 1.0, green: 0.8, blue: 0.2, alpha: 1)
        )
    ]
    
    init(view: OnboardingViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
        showCurrentPage()
    }
    
    func nextTapped() {
        if currentPage < pages.count - 1 {
            currentPage += 1
            showCurrentPage()
        } else {
            finish()
        }
    }
    
    func skipTapped() {
        finish()
    }
    
    func swipeLeft() {
        guard currentPage < pages.count - 1 else { return }
        currentPage += 1
        showCurrentPage()
    }
    
    func swipeRight() {
        guard currentPage > 0 else { return }
        currentPage -= 1
        showCurrentPage()
    }
    
    private func showCurrentPage() {
        let page = pages[currentPage]
        let viewModel = OnboardingPageViewModel(
            title: makeAttributedTitle(for: page),
            subtitle: page.subtitle,
            imageName: page.imageName,
            buttonTitle: currentPage == pages.count - 1 ? "Get Started   " : "Continue   ",
            pageIndex: currentPage,
            totalPages: pages.count
        )
        view?.displayPage(viewModel)
    }
    
    private func makeAttributedTitle(for page: OnboardingData) -> NSAttributedString {
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
        return result
    }
    
    private func finish() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        view?.navigateToHome()
    }
}
