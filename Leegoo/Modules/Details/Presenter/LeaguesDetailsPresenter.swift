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
    private let sportName: String
    private let leagueId: String
    private let leagueName: String
    
    private var upcomingEvents: [Event] = []
    private var latestEvents: [Event] = []
    private var teams: [Team] = []
    
    init(view: LeaguesDetailsViewProtocol,
        sportName: String,
        leagueId: String,
        leagueName: String,
        networkService: NetworkServiceProtocol = NetworkService.shared) {
        self.view = view
        self.sportName = sportName
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
        if sportName.lowercased() == "tennis" {
            teams = []
            view?.showTeams()
        } else {
            fetchTeams()
        }
    }
    
    private func fetchEvents() {
        networkService.fetchEvents(sportName: sportName, leagueId: leagueId) { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.view?.hideLoading()

                switch result {
                case .success(let events):
                    print("DEBUG: fetched events count = \(events.count)")

                    if events.isEmpty {
                        self.upcomingEvents = []
                        self.latestEvents = []
                        self.view?.showUpcomingEvents()
                        self.view?.showLatestEvents()
                        return
                    }

                    self.upcomingEvents = Array(events.prefix(5))
                    self.latestEvents = Array(events.suffix(5))

                    print("DEBUG: upcoming count = \(self.upcomingEvents.count)")
                    print("DEBUG: latest count = \(self.latestEvents.count)")

                    self.view?.showUpcomingEvents()
                    self.view?.showLatestEvents()

                case .failure(let error):
                    print("Error fetching events: \(error)")
                    self.upcomingEvents = []
                    self.latestEvents = []
                    self.view?.showUpcomingEvents()
                    self.view?.showLatestEvents()
                    self.view?.showError(error.localizedDescription)
                }
            }
        }
    }

    
    private func fetchTeams() {
        networkService.fetchTeams(sportName: sportName, leagueId: leagueId) { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success(let teams):
                    print("DEBUG: fetched teams count = \(teams.count)")
                    self.teams = teams
                    self.view?.showTeams()

                case .failure(let error):
                    print("Error fetching teams: \(error)")
                    self.teams = []
                    self.view?.showTeams()
                    self.view?.showError(error.localizedDescription)
                }
            }
        }
    }

}
