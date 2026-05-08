import Foundation
import Alamofire

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(String)
}

protocol NetworkServiceProtocol {
    func fetchLeagues(sportName: String, completion: @escaping (Result<[League], Error>) -> Void)
    func fetchEvents(sportName: String, leagueId: String, completion: @escaping (Result<[Event], Error>) -> Void)
    func fetchTeams(sportName: String, leagueId: String, completion: @escaping (Result<[Team], Error>) -> Void)
    func fetchTeamDetails(sportName: String, teamId: Int, completion: @escaping (Result<Team, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    
    static let shared = NetworkService()
    private init() {}
    
    private let baseURL = "https://apiv2.allsportsapi.com"
    private let apiKey = "3874de8a6677aee6669fb0452cbee68d0ee1cc00aa48e678c49417c40d395dca"
    
    
    func fetchLeagues(sportName: String, completion: @escaping (Result<[League], Error>) -> Void) {
        let urlString = "\(baseURL)/\(sportName)/?met=Leagues&APIkey=\(apiKey)"
        
        performRequest(urlString: urlString, responseType: LeagueResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response.result ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func fetchEvents(sportName: String, leagueId: String, completion: @escaping (Result<[Event], Error>) -> Void) {
        
        let calendar = Calendar.current
        let today = Date()
        
        guard let fromDate = calendar.date(byAdding: .day, value: -30, to: today),
              let toDate = calendar.date(byAdding: .day, value: 30, to: today) else {
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let from = formatter.string(from: fromDate)
        let to = formatter.string(from: toDate)
        
        let timezone = "Africa/Cairo"
        
        let urlString = "\(baseURL)/\(sportName)/?met=Fixtures&APIkey=\(apiKey)&from=\(from)&to=\(to)&leagueId=\(leagueId)&timezone=\(timezone)"
        
        performRequest(urlString: urlString, responseType: EventResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response.result ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchTeams(sportName: String, leagueId: String, completion: @escaping (Result<[Team], Error>) -> Void) {
        let urlString = "\(baseURL)/\(sportName)/?met=Teams&leagueId=\(leagueId)&APIkey=\(apiKey)"
        
        performRequest(urlString: urlString, responseType: TeamResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response.result ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func fetchTeamDetails(sportName: String, teamId: Int, completion: @escaping (Result<Team, Error>) -> Void) {
        let urlString = "\(baseURL)/\(sportName)/?met=Teams&teamId=\(teamId)&APIkey=\(apiKey)"
        
        performRequest(urlString: urlString, responseType: TeamResponse.self) { result in
            switch result {
            case .success(let response):
                if let team = response.result?.first {
                    completion(.success(team))
                } else {
                    completion(.failure(NetworkError.noData))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func performRequest<T: Decodable>(urlString: String,responseType: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        AF.request(urlString)
            .validate()
            .responseDecodable(of: responseType) { response in
                switch response.result {
                case .success(let decoded):
                    completion(.success(decoded))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
