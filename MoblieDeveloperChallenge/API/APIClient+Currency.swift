//
//  APIClient+Currency.swift
//  MoblieDeveloperChallenge
//
//  Created by Kory on 2020/3/27.
//  Copyright © 2020 CHIHYEN. All rights reserved.
//

import Foundation

extension APIClient {
    @discardableResult
    func fetchLiveCurrencies(
        completion: @escaping (Result<CurrencyResponse, Error>)->Void)
        -> URLSessionDataTask? {
            do {
                let request = try APIRequestBuilder.buildFetchCurrencyRequest()
                let task = buildTask(with: request) {
                    [weak self] (result) in
                    guard let self = self else { return }
                    switch result {
                    case .success(let data):
                        do {
                            let currencyResponse = try self.decoder.decode(CurrencyResponse.self, from: data)
                            completion(.success(currencyResponse))
                        } catch let error {
                            completion(.failure(error))
                        }
                        break
                    case .failure(let error):
                        completion(.failure(error))
                    }
                    
                }
                task.resume()
                return task
            } catch let error {
                completion(.failure(error))
                return nil
            }
    }
}
