import Foundation


protocol HomeViewProtocol: AnyObject {
    func navigateToLeagues(with sport: Sport)
    func showNoInternet()
    func toggleThemeWithAnimation()
}

protocol HomePresenterProtocol: AnyObject {
    func numberOfItems() -> Int
    func item(at index: Int) -> Sport
    func didSelectItem(at index: Int)
    func toggleThemeTapped()
}
