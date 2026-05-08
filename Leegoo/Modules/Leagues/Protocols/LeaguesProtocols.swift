
protocol LeaguesViewProtocol: AnyObject {
    func reloadData()
    func showLoading()
    func hideLoading()
    func showError(_ message: String)
    func setTitle(_ title: String)
    func navigateToDetails(league: League)
}

protocol LeaguesPresenterProtocol: AnyObject {
    var numberOfLeagues: Int { get }
    var selectedSport: Sport { get }
    func viewDidLoad()
    func league(at index: Int) -> League
    func searchLeagues(with text: String)
    func didSelectLeague(at index: Int) 

}

