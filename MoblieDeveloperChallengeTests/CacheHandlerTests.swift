//
//  CacheHandlerTests.swift
//  MoblieDeveloperChallengeTests
//
//  Created by Kory on 2020/3/27.
//  Copyright © 2020 CHIHYEN. All rights reserved.
//

import XCTest
@testable import MoblieDeveloperChallenge

class CacheHandlerTests: XCTestCase {
    
    let filename = "test.dat"
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func setUp() {
        let file = getDocumentsDirectory().appendingPathComponent(filename).path
        if FileManager.default.fileExists(atPath: file) {
            try? FileManager.default.removeItem(atPath: file)
        }
    }

    func testSave() throws {
        let handler = CacheHandler<String>(with: filename)
        handler.save(data: ["aa", "bb", "cc"])

        let result = try handler.load()
        XCTAssertNotNil(result)
    }
    
    func testContainData() throws {
        let handler = CacheHandler<String>(with: filename)
        handler.save(data: ["aa", "bb", "cc"])
        guard let result = try handler.load() else {
            XCTFail("shouldn't be nil")
            return
        }
        XCTAssertTrue(result.contains("aa"))
    }

}
