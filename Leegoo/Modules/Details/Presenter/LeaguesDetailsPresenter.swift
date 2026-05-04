//
//  DetailsPresenter.swift
//  Leegoo
//
//  Created by TaqieAllah on 02/05/2026.
//

import Foundation
import CoreData

class LeaguesDetailsPresenter: LeaguesDetailsPresenterProtocol {
    
    weak var view: LeaguesDetailsViewProtocol?
    
    private let networkService: NetworkServiceProtocol
    private let sportName: String
    private let league: League
    private let coreDataManager: CoreDataManager
    
    private var upcomingEvents: [Event] = []
    private var latestEvents: [Event] = []
    private var teams: [Team] = []
    
    init(view: LeaguesDetailsViewProtocol,
        sportName: String,
        league: League,
        networkService: NetworkServiceProtocol = NetworkService.shared,
        coreDataManager: CoreDataManager = .shared) {
        self.view = view
        self.sportName = sportName
        self.league = league
        self.networkService = networkService
        self.coreDataManager = coreDataManager
    }
    
    func viewDidLoad() {
        view?.setTitle(league.leagueName ?? "NoTitle")
        view?.updateFavoriteButton(isFavorite: isFavorite())
        fetchData()
    }
    
    var upcomingCount: Int { upcomingEvents.count }
    var latestCount: Int { latestEvents.count }
    var teamsCount: Int { teams.count }
    var sport: String { sportName }
    
    private var leagueIdString: String? {
        guard let key = league.leagueKey else { return nil }
        return String(key)
    }
        
    func upcomingEvent(at index: Int) -> Event {
        upcomingEvents[index]
    }
    
    func latestEvent(at index: Int) -> Event {
        latestEvents[index]
    }
    
    func team(at index: Int) -> Team {
        teams[index]
    }
    
    func didSelectTeam(at index: Int) {
        let team = teams[index]
        if let teamId = team.teamKey {
            view?.navigateToTeamDetails(teamId: teamId)
        }
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
    
    func isFavorite() -> Bool {
        guard let id = league.leagueKey else { return false }
        return coreDataManager.isLeagueFavorite(id: id)
    }
        
    func toggleFavorite() {
        guard let id = league.leagueKey else { return }
            
        if coreDataManager.isLeagueFavorite(id: id) {
            coreDataManager.deleteLeague(id: id)
        } else {
            coreDataManager.saveLeague(league, sportName: sportName)
        }
            
        view?.updateFavoriteButton(isFavorite: coreDataManager.isLeagueFavorite(id: id))
    }
    
    private func fetchEvents() {
        guard let leagueId = leagueIdString else {
            view?.hideLoading()
            view?.showError("Invalid league id")
            return
        }
        
        networkService.fetchEvents(sportName: sportName, leagueId: leagueId) { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.view?.hideLoading()

                switch result {
                case .success(let events):
                    let calendar = Calendar.current
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                    let startOfToday = calendar.startOfDay(for: Date())
                    
                    // Upcoming: Today and future, must have team names
                    self.upcomingEvents = events.filter { event in
                        guard let dateStr = event.eventDate, let date = formatter.date(from: dateStr) else { return false }
                        let home = (event.eventHomeTeam ?? "").trimmingCharacters(in: .whitespaces)
                        let away = (event.eventAwayTeam ?? "").trimmingCharacters(in: .whitespaces)
                        return date >= startOfToday && !home.isEmpty && !away.isEmpty
                    }.sorted(by: { ($0.eventDate ?? "") < ($1.eventDate ?? "") })
                    
                    // Latest: Past events, must have team names AND a valid result score
                    self.latestEvents = events.filter { event in
                        guard let dateStr = event.eventDate, let date = formatter.date(from: dateStr) else { return false }
                        let home = (event.eventHomeTeam ?? "").trimmingCharacters(in: .whitespaces)
                        let away = (event.eventAwayTeam ?? "").trimmingCharacters(in: .whitespaces)
                        let result = (event.eventFinalResult ?? "").trimmingCharacters(in: .whitespaces)
                        
                        let hasTeams = !home.isEmpty && !away.isEmpty
                        let hasResult = !result.isEmpty && result != "-" && result != " - "
                        
                        return date < startOfToday && hasTeams && hasResult
                    }.sorted(by: { ($0.eventDate ?? "") > ($1.eventDate ?? "") })

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
        guard let leagueId = leagueIdString else {
            view?.hideLoading()
            view?.showError("Invalid league id")
            return
        }
        
        networkService.fetchTeams(sportName: sportName, leagueId: leagueId) { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success(let teams):
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
