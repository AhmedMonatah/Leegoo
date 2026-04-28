import Foundation

struct LeagueResponse: Codable {
    let countries: [League]
}

struct League: Codable {
    let idLeague: String?
    let strLeague: String?
    let strBadge: String?
    let strYoutube: String?
    let strSport: String?
}
