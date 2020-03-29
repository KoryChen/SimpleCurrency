//
//  APIRequestBuilderTests.swift
//  MoblieDeveloperChallengeTests
//
//  Created by Kory on 2020/3/29.
//  Copyright © 2020 CHIHYEN. All rights reserved.
//

import XCTest
@testable import MoblieDeveloperChallenge

class APIRequestBuilderTests: XCTestCase {

    let baseURLString: String = "https://google.com"
    func testBaseURLRequest() {
        let builder = APIRequestBuilder(urlString: baseURLString, method: .GET)
        
        XCTAssertEqual(try? builder.build().url?.absoluteString, baseURLString)
    }
    
    func testHTTPMethod() {
        let builder = APIRequestBuilder(urlString: baseURLString, method: .HEAD)
        XCTAssertEqual(try? builder.build().httpMethod, "HEAD")
    }
    
    func testAppendPath() {
        let builder = APIRequestBuilder(urlString: baseURLString, method: .GET)
            .path("test")
        XCTAssertEqual(try? builder.build().url?.absoluteString, "https://google.com/test")
    }
    
    func testPathParameter() {
        let builder = APIRequestBuilder(urlString: baseURLString, method: .GET).query(key: "key", value: "test")
        XCTAssertEqual(try? builder.build().url?.absoluteString, "https://google.com?key=test")
    }
    
    func testURLEncodingQuery() {
        let baseURL = "https://google.com?key=test|1"
        let escapedString = baseURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let builder = APIRequestBuilder(urlString: baseURLString, method: .GET).query(key: "key", value: "test|1")
        XCTAssertEqual(try? builder.build().url?.absoluteString, escapedString)
    }
}
