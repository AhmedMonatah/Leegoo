

protocol LeaguesPresenterProtocol: AnyObject {
    var numberOfLeagues: Int { get }
    func viewDidLoad()
    func league(at index: Int) -> League
    func searchLeagues(with text: String)
    func didSelectLeague(at index: Int) 

}

