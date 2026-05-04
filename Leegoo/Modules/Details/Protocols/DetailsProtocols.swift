//
//  DetailsProtocols.swift
//  Leegoo
//
//  Created by TaqieAllah on 02/05/2026.
//

import Foundation

protocol LeaguesDetailsViewProtocol: AnyObject {
    func showLoading()
    func hideLoading()
    func showError(_ message: String)
    
    func showUpcomingEvents()
    func showLatestEvents()
    func showTeams()
    
    func setTitle(_ title: String)
    func navigateToTeamDetails(teamId: Int)
}

protocol LeaguesDetailsPresenterProtocol: AnyObject {
    var upcomingCount: Int { get }
    var latestCount: Int { get }
    var teamsCount: Int { get }
    var sport: String { get }
    
    func viewDidLoad()
    
    func upcomingEvent(at index: Int) -> Event
    func latestEvent(at index: Int) -> Event
    func team(at index: Int) -> Team
    func didSelectTeam(at index: Int)
}
