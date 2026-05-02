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
            let from = "2026-05-02"
            let to   = "2026-05-15"
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
    
    private func performRequest<T: Codable>(urlString: String, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        print("REQUEST:", urlString)

        AF.request(urlString).validate().responseData { response in
            if let data = response.data {
                print(String(data: data, encoding: .utf8) ?? "No response text")
            }

            switch response.result {
            case .success(let data):
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decoded))
                } catch {
                    print("DECODE ERROR:", error)
                    completion(.failure(NetworkError.decodingError))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}
