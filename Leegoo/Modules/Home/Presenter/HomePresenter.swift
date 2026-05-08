import Foundation




class HomePresenter: HomePresenterProtocol {
    
        
    weak var view: HomeViewProtocol?
    
    private let items: [Sport] = [
        Sport(title: "FOOTBALL", imageName: "football", endpoint: "football"),
        Sport(title: "BASKETBALL", imageName: "basketball", endpoint: "basketball"),
        Sport(title: "TENNIS", imageName: "tennis", endpoint: "tennis"),
        Sport(title: "CRICKET", imageName: "cricket", endpoint: "cricket")
    ]
    
    init(view: HomeViewProtocol) {
        self.view = view
    }
    
    func numberOfItems() -> Int {
        items.count
    }
        
    func item(at index: Int) -> Sport {
        items[index]
    }
        
    func didSelectItem(at index: Int) {
        let item = items[index]
        view?.navigateToLeagues(with: item)
    }
    
    func toggleThemeTapped() {
        guard NetworkMonitor.shared.isConnected else {
            view?.showNoInternet()
            return
        }
        view?.toggleThemeWithAnimation()
    }
}
