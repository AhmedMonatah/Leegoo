//
//  LeegooTests.swift
//  LeegooTests
//
//  Created by TaqieAllah on 08/05/2026.
//

import XCTest
@testable import Leegoo

final class LeegooTests: XCTestCase {

    var networkService: NetworkService!
    var fakeNetwork: FakeNetworkService!

    override func setUp() {
        super.setUp()
        networkService = NetworkService.shared
        fakeNetwork = FakeNetworkService()
    }

    override func tearDown() {
        networkService = nil
        fakeNetwork = nil
        super.tearDown()
    }

    func testFetchLeaguesReturnsSuccess() {
        let exp = expectation(description: "Waiting for leagues API")

        networkService.fetchLeagues(sportName: "football") { result in
            switch result {
            case .success(let leagues):
                XCTAssertFalse(leagues.isEmpty)
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
            exp.fulfill()
        }

        waitForExpectations(timeout: 10)
    }

    func testFetchTeamsReturnsSuccess() {
        let exp = expectation(description: "Waiting for teams API")

        networkService.fetchTeams(sportName: "football", leagueId: "152") { result in
            switch result {
            case .success(let teams):
                XCTAssertFalse(teams.isEmpty)
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
            exp.fulfill()
        }

        waitForExpectations(timeout: 10)
    }

    func testFetchEventsReturnsSuccess() {
        let exp = expectation(description: "Waiting for events API")

        networkService.fetchEvents(sportName: "football", leagueId: "152") { result in
            switch result {
            case .success(let events):
                XCTAssertNotNil(events)
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
            exp.fulfill()
        }

        waitForExpectations(timeout: 10)
    }

    func testFetchTeamDetailsReturnsSuccess() {
        let exp = expectation(description: "Waiting for team details API")

        networkService.fetchTeamDetails(sportName: "football", teamId: 96) { result in
            switch result {
            case .success(let team):
                XCTAssertNotNil(team)
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
            exp.fulfill()
        }

        waitForExpectations(timeout: 10)
    }

    func testFetchLeaguesSuccess() {
        fakeNetwork.shouldReturnError = false
        
        fakeNetwork.fetchLeagues { leagues, error in
            XCTAssertNil(error)
            XCTAssertNotNil(leagues)
        }
    }

    func testFetchLeaguesFailure() {
        fakeNetwork.shouldReturnError = true
            
        fakeNetwork.fetchLeagues { leagues, error in
            XCTAssertNil(leagues)
            XCTAssertNotNil(error)
        }
    }
}
