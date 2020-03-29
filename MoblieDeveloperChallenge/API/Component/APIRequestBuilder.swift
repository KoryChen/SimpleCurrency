//
//  APIRequestBuilder.swift
//  MoblieDeveloperChallenge
//
//  Created by Kory on 2020/3/29.
//  Copyright © 2020 CHIHYEN. All rights reserved.
//

import Foundation

class APIRequestBuilder {
    private let base: String
    private var query: [String: String] = [:]
    private var paths: [String] = []
    private var method: HTTPMethod
    init(urlString: String = APIConstants.apiDomain, method: HTTPMethod) {
        self.base = urlString
        self.method = method
    }
    
    func needsAuthorization() -> APIRequestBuilder {
        query["access_key"] = APIConstants.apiKey
        return self
    }
    
    func query(key: String, value: String) -> APIRequestBuilder {
        query[key] = value
        return self
    }
    
    func path(_ path: String) -> APIRequestBuilder {
        paths.append(path)
        return self
    }
    
    func build() throws -> URLRequest {
        guard let baseString = base.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            var url = URL(string: baseString) else {
                throw GeneralError.formatIncorrect
        }
        
        for path in paths {
            url.appendPathComponent(path)
        }
        
        if var comp = URLComponents(url: url, resolvingAgainstBaseURL: false),
            !query.isEmpty {
            let querys = query.sorted {$0.key < $1.key}.map({ URLQueryItem(name: $0.key, value: $0.value) }) as [URLQueryItem]
            var items = comp.queryItems ?? []
            items.append(contentsOf: querys)
            comp.queryItems = items
            if let newUrl = comp.url {
                url = newUrl
            }
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
    
}

extension APIRequestBuilder {
    static func buildFetchCurrencyRequest() throws -> URLRequest {
        try APIRequestBuilder(method: .GET)
        .path("live")
        .needsAuthorization()
        .build()
    }
}
