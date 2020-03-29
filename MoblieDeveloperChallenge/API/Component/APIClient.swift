//
//  APIClient.swift
//  MoblieDeveloperChallenge
//
//  Created by Kory on 2020/3/26.
//  Copyright © 2020 CHIHYEN. All rights reserved.
//

import Foundation

class APIClient {
    private let session: URLSession
    let decoder = JSONDecoder()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    @discardableResult
    func buildTask(
        with request: URLRequest,
        completion: @escaping (Result<Data, Error>)->Void) -> URLSessionDataTask {
        return session.dataTask(with: request) {
            (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.nilData))
                return
            }
            
            completion(.success(data))
        }
    }
}
