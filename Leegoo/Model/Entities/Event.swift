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
    
    static let dummy = Event(idEvent: "0", strEvent: "Any Match", dateEvent: "2024-05-24", strTime: "16:00:00", intHomeScore: "0", intAwayScore: "0", idHomeTeam: "0", idAwayTeam: "0", strHomeTeam: "Home", strAwayTeam: "Away", strThumb: nil)
}
