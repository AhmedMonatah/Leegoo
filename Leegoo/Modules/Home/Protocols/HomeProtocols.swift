import Foundation

protocol HomeViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func renderSports(_ sports: [Sport])
    func showError(_ message: String)
}

protocol HomePresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSelectSport(_ sport: Sport)
}
