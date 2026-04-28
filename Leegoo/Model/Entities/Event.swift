import Foundation

struct EventResponse: Codable {
    let events: [Event]?
}

struct Event: Codable {
    let idEvent: String?
    let strEvent: String?
    let dateEvent: String?
    let strTime: String?
    let intHomeScore: String?
    let intAwayScore: String?
    let idHomeTeam: String?
    let idAwayTeam: String?
    let strHomeTeam: String?
    let strAwayTeam: String?
    let strThumb: String?
}
