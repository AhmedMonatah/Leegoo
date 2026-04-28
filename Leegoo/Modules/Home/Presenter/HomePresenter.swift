import Foundation

class HomePresenter: HomePresenterProtocol {
    
    weak var view: HomeViewProtocol?
    private let networkService: NetworkServiceProtocol
    
    init(view: HomeViewProtocol, networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.view = view
        self.networkService = networkService
    }
    
    func viewDidLoad() {
        fetchSports()
    }
    
    private func fetchSports() {
        view?.showLoading()
        networkService.fetchSports { [weak self] result in
            self?.view?.hideLoading()
            switch result {
            case .success(let sports):
                self?.view?.renderSports(sports)
            case .failure(let error):
                self?.view?.showError(error.localizedDescription)
            }
        }
    }
    
    func didSelectSport(_ sport: Sport) {
    }
}
