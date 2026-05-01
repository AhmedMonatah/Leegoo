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



struct Player {
    let number: Int
    let name: String
    let age: Int
    let position: PlayerPosition
    var matchesPlayed: Int?
    var statValue: Int?      // saves (GK) or goals (outfield)
    var rating: Double?
    var isCaptain: Bool
    var isInjured: Bool


    var statLabel: String {
        position == .goalkeeper ? "Saves" : "Goals"
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



struct SquadData {

    static let teamName   = "Juventus FC"
    static let teamID     = "Team ID: 96"

    static func randomStat(position: PlayerPosition) -> (mp: Int?, stat: Int?, rating: Double?) {
        let played = Bool.random()
        guard played else { return (nil, nil, nil) }
        let mp  = Int.random(in: 5...30)
        let stat: Int
        let rating = Double(Int.random(in: 580...780)) / 100.0
        switch position {
        case .goalkeeper: stat = Int.random(in: 5...70)
        case .defender:   stat = Int.random(in: 0...6)
        case .midfielder: stat = Int.random(in: 0...10)
        case .forward:    stat = Int.random(in: 3...20)
        }
        return (mp, stat, rating)
    }

    static func generatePlayers() -> [Player] {
        var players: [Player] = []

        let gkData: [(Int, String, Int)] = [
            (16, "Michele Di Gregorio", 28),
            (29, "Matteo Fuscaldo",     21),
            (37, "Raffaele Huli",       17),
            (22, "Stefano Mangiapoco",  22),
            (1,  "Mattia Perin",        33),
            (23, "Carlo Pinsoglio",     36),
            (51, "Riccardo Radu",       18),
            (42, "Simone Scaglia",      21),
            (77, "Luca Torriani",       20)
        ]
        for (num, name, age) in gkData {
            let s = randomStat(position: .goalkeeper)
            players.append(Player(number: num, name: name, age: age,
                                  position: .goalkeeper,
                                  matchesPlayed: s.mp, statValue: s.stat, rating: s.rating,
                                  isCaptain: false, isInjured: Bool.random() && age > 30))
        }

        let defData: [(Int, String, Int, Bool)] = [
            (3,  "Bremer",          29, true),
            (32, "Juan Cabal",      25, false),
            (6,  "Danilo",          33, false),
            (2,  "Mattia De Sciglio", 31, false),
            (17, "Luca Pellegrini", 25, false),
            (12, "Alex Sandro",     33, false),
            (19, "Leonardo Bonucci",36, false),
            (4,  "Federico Gatti",  26, false),
            (24, "Nicolò Fagioli", 23, false),
            (33, "Federico Chiesa", 27, false),
            (11, "Arek Milik",      30, false)
        ]
        for (num, name, age, cap) in defData {
            let s = randomStat(position: .defender)
            players.append(Player(number: num, name: name, age: age,
                                  position: .defender,
                                  matchesPlayed: s.mp, statValue: s.stat, rating: s.rating,
                                  isCaptain: cap, isInjured: Bool.random() && !cap))
        }

        let midData: [(Int, String, Int)] = [
            (5,  "Manuel Locatelli", 26),
            (25, "Adrien Rabiot",    29),
            (8,  "Weston McKennie", 25),
            (14, "Fabio Miretti",   20),
            (27, "Nicolò Rovella",  22),
            (28, "Nicolò Fagioli", 23),
            (38, "Hans Nicolussi",  23)
        ]
        for (num, name, age) in midData {
            let s = randomStat(position: .midfielder)
            players.append(Player(number: num, name: name, age: age,
                                  position: .midfielder,
                                  matchesPlayed: s.mp, statValue: s.stat, rating: s.rating,
                                  isCaptain: false, isInjured: Bool.random() && age > 28))
        }

        let fwdData: [(Int, String, Int)] = [
            (9,  "Dusan Vlahovic",  24),
            (7,  "Federico Chiesa", 27),
            (10, "Paul Pogba",      31),
            (18, "Moise Kean",      24),
            (21, "Timothy Weah",    24),
            (45, "Kenan Yildiz",    19),
            (47, "Samuel Mbangula", 21)
        ]
        for (num, name, age) in fwdData {
            let s = randomStat(position: .forward)
            players.append(Player(number: num, name: name, age: age,
                                  position: .forward,
                                  matchesPlayed: s.mp, statValue: s.stat, rating: s.rating,
                                  isCaptain: false, isInjured: Bool.random() && age > 29))
        }

        return players
    }
}
