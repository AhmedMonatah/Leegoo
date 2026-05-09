//
//  Files.swift
//  Leegoo
//
//  Created by Ahmed Monatah on 01/05/2026.
//



import UIKit


enum PlayerPosition: String, CaseIterable {
    case goalkeeper = "Goalkeepers"
    case defender   = "Defenders"
    case midfielder = "Midfielders"
    case forward    = "Forwards"
}

enum FilterTab: Int {
    case all = 0, goalkeepers, defenders, midfielders, forwards
}



struct Player: Codable {
    let playerKey: Int?
    let playerName: String?
    let playerNumber: String?
    let playerCountry: String?
    let playerType: String?
    let playerAge: String?
    let playerMatchPlayed: String?
    let playerGoals: String?
    let playerYellowCards: String?
    let playerRedCards: String?
    let playerImage: String?

    enum CodingKeys: String, CodingKey {
        case playerKey = "player_key"
        case playerName = "player_name"
        case playerNumber = "player_number"
        case playerCountry = "player_country"
        case playerType = "player_type"
        case playerAge = "player_age"
        case playerMatchPlayed = "player_match_played"
        case playerGoals = "player_goals"
        case playerYellowCards = "player_yellow_cards"
        case playerRedCards = "player_red_cards"
        case playerImage = "player_image"
    }

    var name: String { playerName ?? "Unknown Player" }
    var number: String { 
        if let num = playerNumber, !num.isEmpty { return num }
        return "-"
    }
    var age: String { playerAge ?? "N/A" }
    var imageURL: String { playerImage ?? "" }
    private func defaultOrDash(_ value: String?) -> String {
        guard let val = value, !val.isEmpty else { return "-" }
        return val
    }
    
    var goals: String { defaultOrDash(playerGoals) }
    var matches: String { defaultOrDash(playerMatchPlayed) }
    var yellowCards: String { defaultOrDash(playerYellowCards) }
    var redCards: String { defaultOrDash(playerRedCards) }
    
    var position: PlayerPosition {
        switch playerType {
        case "Goalkeepers": return .goalkeeper
        case "Defenders":   return .defender
        case "Midfielders": return .midfielder
        case "Forwards":    return .forward
        default:            return .midfielder
        }
    }

    var placeholderColor: UIColor {
        switch position {
        case .goalkeeper: return UIColor(red: 0.18, green: 0.55, blue: 0.34, alpha: 1)
        case .defender:   return UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1)
        case .midfielder: return UIColor(red: 0.20, green: 0.24, blue: 0.60, alpha: 1)
        case .forward:    return UIColor(red: 0.78, green: 0.08, blue: 0.08, alpha: 1)
        }
    }
}



