import Foundation

struct LeagueResponse: Codable {
    let success: Int?
    let result: [League]?
}

struct League: Codable {
    let leagueKey: Int?
    let leagueName: String?
    let countryName: String?
    let leagueLogo: String?
    let countryLogo: String?
    let leagueYear: String?
    let leagueSurface: String?

    enum CodingKeys: String, CodingKey {
        case leagueKey = "league_key"
        case leagueName = "league_name"
        case countryName = "country_name"
        case leagueLogo = "league_logo"
        case countryLogo = "country_logo"
        case leagueYear = "league_year"
        case leagueSurface = "league_surface"
    }
}
