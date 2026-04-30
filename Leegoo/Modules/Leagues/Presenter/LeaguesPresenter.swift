
import Foundation

class LeaguesPresenter: LeaguesPresenterProtocol {
    
    weak var view: LeaguesViewProtocol?
    
    private var leagues: [League] = []
    private let sportTitle: String
    private let selectedSport: Sport
    private let networkService: NetworkServiceProtocol
    
    init(view: LeaguesViewProtocol,title: String ,selectedSport: Sport,
         networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.view = view
        self.selectedSport = selectedSport
        self.networkService = networkService
        self.sportTitle = title
    }
    
    var numberOfLeagues: Int {
        leagues.count
    }
    
    func viewDidLoad() {
        view?.setTitle(sportTitle)
        fetchLeagues()
    }
    
    func league(at index: Int) -> League {
        leagues[index]
    }
    
    private func fetchLeagues() {
        view?.showLoading()
        
        networkService.fetchLeagues(sportName: selectedSport.endpoint) { [weak self] result in
            guard let self = self else { return }
            
            self.view?.hideLoading()
            
            switch result {
            case .success(let leagues):
                self.leagues = leagues
                self.view?.reloadData()
            case .failure(let error):
                self.view?.showError(error.localizedDescription)
            }
        }
    }
}
