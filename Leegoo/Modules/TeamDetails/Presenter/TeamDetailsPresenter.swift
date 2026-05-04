import Foundation

class TeamDetailsPresenter: TeamDetailsPresenterProtocol {
    
    weak var view: TeamDetailsViewProtocol?
    private let networkService: NetworkServiceProtocol
    private let sportName: String
    private let teamId: Int
    
    private var team: Team?
    private var activeFilter: FilterTab = .all
    private var sections: [PlayerPosition] = []
    
    init(view: TeamDetailsViewProtocol, sportName: String, teamId: Int, networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.view = view
        self.sportName = sportName
        self.teamId = teamId
        self.networkService = networkService
    }
    
    func viewDidLoad() {
        fetchTeamDetails()
    }

    var activeFilterTag: Int {
        return activeFilter.rawValue
    }

    var numberOfSections: Int {
        return sections.count
    }
    
    func section(at index: Int) -> PlayerPosition {
        return sections[index]
    }
    
    func numberOfPlayers(in section: Int) -> Int {
        guard let team = team, let players = team.players else { return 0 }
        let position = sections[section]
        return players.filter { $0.position == position }.count
    }
    
    func player(at indexPath: IndexPath) -> Player {
        let position = sections[indexPath.section]
        guard let team = team, let players = team.players else { fatalError() }
        let posPlayers = players.filter { $0.position == position }
        return posPlayers[indexPath.row]
    }
    
    func filterPlayers(by tab: Int) {
        guard let filterTab = FilterTab(rawValue: tab) else { return }
        
        activeFilter = filterTab
        
        switch filterTab {
        case .all:
            sections = PlayerPosition.allCases
        case .goalkeepers:
            sections = [.goalkeeper]
        case .defenders:
            sections = [.defender]
        case .midfielders:
            sections = [.midfielder]
        case .forwards:
            sections = [.forward]
        }
        
        if let team = team {
            view?.showTeamDetails(team)
        }
    }
    
    private func fetchTeamDetails() {
        view?.showLoading()
        networkService.fetchTeamDetails(sportName: sportName, teamId: teamId) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.view?.hideLoading()
                switch result {
                case .success(let team):
                    self.team = team
                    self.filterPlayers(by: self.activeFilter.rawValue) 
                    self.view?.showTeamDetails(team)
                case .failure(let error):
                    self.view?.showError(error.localizedDescription)
                }
            }
        }
    }
}
