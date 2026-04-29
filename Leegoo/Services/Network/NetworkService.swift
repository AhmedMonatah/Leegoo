import Foundation
import Alamofire

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(String)
}

protocol NetworkServiceProtocol {
  //  func fetchSports(completion: @escaping (Result<[Sport], Error>) -> Void)
    func fetchLeagues(sportName: String, completion: @escaping (Result<[League], Error>) -> Void)
    func fetchEvents(leagueId: String, completion: @escaping (Result<[Event], Error>) -> Void)
    func fetchTeams(leagueName: String, completion: @escaping (Result<[Team], Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    
    static let shared = NetworkService()
    private init() {}
    
    private let baseURL = "https://www.thesportsdb.com/api/v1/json/3"
    
//    func fetchSports(completion: @escaping (Result<[Sport], Error>) -> Void) {
//        let urlString = "\(baseURL)/all_sports.php"
//        performRequest(urlString: urlString, responseType: SportResponse.self) { result in
//            switch result {
//            case .success(let response):
//                completion(.success(response.sports))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
    
    func fetchLeagues(sportName: String, completion: @escaping (Result<[League], Error>) -> Void) {
        let urlString = "\(baseURL)/search_all_leagues.php?s=\(sportName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        performRequest(urlString: urlString, responseType: LeagueResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response.countries))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchEvents(leagueId: String, completion: @escaping (Result<[Event], Error>) -> Void) {
        let urlString = "\(baseURL)/eventsseason.php?id=\(leagueId)"
        performRequest(urlString: urlString, responseType: EventResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response.events ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchTeams(leagueName: String, completion: @escaping (Result<[Team], Error>) -> Void) {
        let urlString = "\(baseURL)/search_all_teams.php?l=\(leagueName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        performRequest(urlString: urlString, responseType: TeamResponse.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response.teams ?? []))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func performRequest<T: Codable>(urlString: String, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let _ = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        AF.request(urlString).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
