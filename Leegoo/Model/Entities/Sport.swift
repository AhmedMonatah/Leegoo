import Foundation

struct SportResponse: Codable {
    let sports: [Sport]
}

struct Sport: Codable {
    let idSport: String?
    let strSport: String?
    let strSportThumb: String?
    let strSportDescription: String?
}
