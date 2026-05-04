import Foundation

protocol TeamDetailsViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showError(_ message: String)
    func showTeamDetails(_ team: Team)
}

protocol TeamDetailsPresenterProtocol: AnyObject {
    func viewDidLoad()
    func filterPlayers(by tab: Int)
    var activeFilterTag: Int { get }
    
    var numberOfSections: Int { get }
    func section(at index: Int) -> PlayerPosition
    func numberOfPlayers(in section: Int) -> Int
    func player(at indexPath: IndexPath) -> Player
}
