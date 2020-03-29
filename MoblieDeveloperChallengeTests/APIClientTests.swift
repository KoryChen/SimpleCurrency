//
//  APIClientTests.swift
//  MoblieDeveloperChallengeTests
//
//  Created by Kory on 2020/3/29.
//  Copyright © 2020 CHIHYEN. All rights reserved.
//

import XCTest
@testable import MoblieDeveloperChallenge

class MockURLSessionDataTask: URLSessionDataTask {
    var fakeState: URLSessionTask.State
    
    init(state:URLSessionTask.State = URLSessionTask.State.running) {
        self.fakeState = state
    }
}
class APIClientTests: XCTestCase {
    class MockSession: URLSession {
        static let mockData = """
            {
               "success": true,
               "terms": "https://currencylayer.com/terms",
               "privacy": "https://currencylayer.com/privacy",
               "timestamp": 1585240445,
               "source": "USD",
               "quotes": {
                   "USDAED": 3.67295,
                   "USDAFN": 76.802101,
               }
           }
        """.data(using: .utf8)
        static let mockMalData = """
                    '{
                          "success": true,
                          "terms": "https://currencylayer.com/terms",
                          "privacy": "https://currencylayer.com/privacy",
                          "timestamp": 1585240445,
                          "source": "USD",
                          "quotes": {
                              "USDAED": 3.67295,
                              "USDAFN": 76.802101
                      }
           """.data(using: .utf8)
        enum MockType {
            case success
            case decodeFail
            case error
            case noData
        }
        
        var type: MockType = .success
        convenience init(type: MockType) {
            self.init()
            self.type = type
        }
        
        override init() {
        }
        override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            switch type {
            case .success:
                completionHandler(MockSession.mockData, nil, nil)
            case .decodeFail:
                completionHandler(MockSession.mockMalData, nil, nil)
            case .error:
                completionHandler(nil, nil, APIError.nilData)
            case .noData:
                completionHandler(nil,nil,nil)
            }
            return MockURLSessionDataTask()
        }
    }
    
    func testSuccessRequest() {
        let mockSesstion = MockSession(type: .success)
        let apiClient = APIClient(session: mockSesstion)
        let request = URLRequest(url: URL(string: "https://goolge.com")!)
        apiClient.buildTask(with: request) { (result) in
            switch result {
            case .success(let data):
                XCTAssertNotNil(data)
            case .failure(_):
                break
            }
        }.resume()
    }
    
    func testRunTaskNoData() {
        let mockSesstion = MockSession(type: .noData)
        let apiClient = APIClient(session: mockSesstion)
        let request = URLRequest(url: URL(string: "https://goolge.com")!)
        apiClient.buildTask(with: request) { (result) in
            switch result {
            case .success(_):
                XCTAssert(false)
            case .failure(let error):
                XCTAssertTrue(error is APIError)
            }
        }.resume()
    }
    
    func testRunTaskError() {
        let mockSesstion = MockSession(type: .error)
        let apiClient = APIClient(session: mockSesstion)
        let request = URLRequest(url: URL(string: "https://goolge.com")!)
        apiClient.buildTask(with: request) { (result) in
            switch result {
            case .success(_):
                XCTAssert(false)
            case .failure(let error):
                XCTAssertTrue(error is APIError)
            }
        }.resume()
    }
    
    func testFetchCurrency() {
        let mockSesstion = MockSession(type: .success)
        let apiClient = APIClient(session: mockSesstion)
        apiClient.fetchLiveCurrencies { (result) in
            switch result {
            case .success(let response):
                XCTAssertNotNil(response)
                XCTAssertEqual(response.quotes.count, 2)
            case .failure(_):
                XCTAssert(false)
            }
            }?.resume()
    }
    
    func testFetchMalDataCurrency() {
        let mockSesstion = MockSession(type: .decodeFail)
        let apiClient = APIClient(session: mockSesstion)
        apiClient.fetchLiveCurrencies { (result) in
            switch result {
            case .success(_):
                XCTAssert(false)
            case .failure(let error):
                XCTAssertTrue(error is DecodingError)
            }
            }?.resume()
    }
    
    
}
