
import Foundation

class LeaguesPresenter: LeaguesPresenterProtocol {
    
    weak var view: LeaguesViewProtocol?
    
    private var leagues: [League] = []
    private var filteredLeagues: [League] = []
    private let sportTitle: String
    let selectedSport: Sport
    private let networkService: NetworkServiceProtocol
    
    init(view: LeaguesViewProtocol,title: String ,selectedSport: Sport,
         networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.view = view
        self.selectedSport = selectedSport
        self.networkService = networkService
        self.sportTitle = title
    }
    
    var numberOfLeagues: Int {
        filteredLeagues.count
    }
    
    func viewDidLoad() {
        view?.setTitle(sportTitle)
        fetchLeagues()
    }
    
    func league(at index: Int) -> League {
        filteredLeagues[index]
    }
    
    func searchLeagues(with text: String) {
        if text.isEmpty {
            filteredLeagues = leagues
        } else {
            filteredLeagues = leagues.filter { ($0.leagueName ?? "").lowercased().contains(text.lowercased()) }
        }
        view?.reloadData()
    }
    
    private func fetchLeagues() {
        view?.showLoading()
        
        networkService.fetchLeagues(sportName: selectedSport.endpoint) { [weak self] result in
            guard let self = self else { return }
            
            self.view?.hideLoading()
            
            switch result {
            case .success(let leagues):
                self.leagues = leagues
                self.filteredLeagues = leagues
                self.view?.reloadData()
            case .failure(let error):
                self.view?.showError(error.localizedDescription)
            }
        }
    }
    
    func didSelectLeague(at index: Int) {
        let league = filteredLeagues[index]
        view?.navigateToDetails(league: league)
    }
    
}
