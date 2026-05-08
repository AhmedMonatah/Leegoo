import Foundation

struct TeamHeaderViewModel {
    let name: String
    let initials: String
    let idText: String
    let logoURL: String?
    let totalPlayers: String
    let gkCount: String
    let defCount: String
}

protocol TeamDetailsViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showError(_ message: String)
    func showTeamDetails(_ viewModel: TeamHeaderViewModel)
}

protocol TeamDetailsPresenterProtocol: AnyObject {
    func viewDidLoad()
    func filterPlayers(by tab: Int)
    var activeFilterTag: Int { get }
    
    var numberOfSections: Int { get }
    func section(at index: Int) -> PlayerPosition
    func numberOfPlayers(in section: Int) -> Int
    func player(at indexPath: IndexPath) -> Player
    func makePlayerViewModel(from player: Player) -> PlayerCellViewModel
}
