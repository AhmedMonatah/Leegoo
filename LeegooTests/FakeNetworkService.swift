//
//  FakeNetworkService.swift
//  LeegooTests
//
//  Created by TaqieAllah on 08/05/2026.
//

import Foundation
@testable import Leegoo

class FakeNetworkService {
    
    var shouldReturnError = false
    
    func fetchLeagues(completion: @escaping ([League]?, Error?) -> Void) {
        if shouldReturnError {
            let error = NSError(domain: "test", code: 1)
            completion(nil, error)
        } else {
            let leagues: [League] = []
            completion(leagues, nil)
        }
    }
}
