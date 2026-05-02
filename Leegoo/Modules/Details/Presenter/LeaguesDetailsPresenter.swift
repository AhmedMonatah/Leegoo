//
//  DetailsPresenter.swift
//  Leegoo
//
//  Created by TaqieAllah on 02/05/2026.
//

import Foundation


class LeaguesDetailsPresenter: LeaguesDetailsPresenterProtocol {
    
    weak var view: LeaguesDetailsViewProtocol?
    
    private let networkService: NetworkServiceProtocol
    private let leagueId: String
    private let leagueName: String
    
    private var upcomingEvents: [Event] = []
    private var latestEvents: [Event] = []
    private var teams: [Team] = []
    
    init(view: LeaguesDetailsViewProtocol,
         leagueId: String,
         leagueName: String,
         networkService: NetworkServiceProtocol = NetworkService.shared) {
        
        self.view = view
        self.leagueId = leagueId
        self.leagueName = leagueName
        self.networkService = networkService
    }
    
    func viewDidLoad() {
        view?.setTitle(leagueName)
        fetchData()
    }
    
    var upcomingCount: Int { upcomingEvents.count }
    var latestCount: Int { latestEvents.count }
    var teamsCount: Int { teams.count }
    
    func upcomingEvent(at index: Int) -> Event {
        upcomingEvents[index]
    }
    
    func latestEvent(at index: Int) -> Event {
        latestEvents[index]
    }
    
    func team(at index: Int) -> Team {
        teams[index]
    }
    
    private func fetchData() {
        view?.showLoading()
        
        fetchEvents()
        fetchTeams()
    }
    
    private func fetchEvents() {
        networkService.fetchEvents(leagueId: leagueId) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.view?.hideLoading()
                
                switch result {
                case .success(let events):
                    self.upcomingEvents = Array(events.prefix(5))
                    self.latestEvents = Array(events.suffix(from: min(events.count, 5)))
                    
                    if self.upcomingEvents.isEmpty && self.latestEvents.isEmpty {
                        // Fallback to dummy if empty success (optional, but good for testing)
                        self.upcomingEvents = Array(repeating: .dummy, count: 3)
                        self.latestEvents = Array(repeating: .dummy, count: 5)
                    }
                    
                    self.view?.showUpcomingEvents()
                    self.view?.showLatestEvents()
                    
                case .failure(let error):
                    print("Error fetching events: \(error)")
                    // Fallback to dummy data
                    self.upcomingEvents = Array(repeating: .dummy, count: 3)
                    self.latestEvents = Array(repeating: .dummy, count: 5)
                    
                    self.view?.showUpcomingEvents()
                    self.view?.showLatestEvents()
                    self.view?.showError(error.localizedDescription)
                }
            }
        }
    }
    
    private func fetchTeams() {
        networkService.fetchTeams(leagueName: leagueName) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let teams):
                    self.teams = teams
                    if self.teams.isEmpty {
                         self.teams = Array(repeating: .dummy, count: 10)
                    }
                    self.view?.showTeams()
                    
                case .failure(let error):
                    print("Error fetching teams: \(error)")
                    self.teams = Array(repeating: .dummy, count: 10)
                    self.view?.showTeams()
                    self.view?.showError(error.localizedDescription)
                }
            }
        }
    }
}
