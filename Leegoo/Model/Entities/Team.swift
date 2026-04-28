import Foundation

struct TeamResponse: Codable {
    let teams: [Team]?
}

struct Team: Codable {
    let idTeam: String?
    let strTeam: String?
    let strTeamBadge: String?
    let strTeamLogo: String?
    let strDescriptionEN: String?
    let strStadium: String?
    let strCountry: String?
    let intFormedYear: String?
    let strWebsite: String?
    let strFacebook: String?
    let strTwitter: String?
    let strInstagram: String?
}
