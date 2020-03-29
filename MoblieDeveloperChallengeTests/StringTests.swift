//
//  StringTests.swift
//  MoblieDeveloperChallengeTests
//
//  Created by Kory on 2020/3/29.
//  Copyright © 2020 CHIHYEN. All rights reserved.
//

import XCTest
@testable import MoblieDeveloperChallenge

class StringTests: XCTestCase {
    
    func testRemovePrefix() {
        let prefix = "USD"
        let remainString = "abcd"
        let context = "\(prefix)\(remainString)"
        
        XCTAssertEqual(context.deletingPrefix(prefix), remainString)
    }
    
    func testIsValidWithDecimalNumber() {
        let valid = "9"
        XCTAssertTrue(valid.isValidInputNumber())
    }
    
    func testIsValidWithZeroDecimalNumber() {
        let valid = "9.00"
        XCTAssertTrue(valid.isValidInputNumber())
    }
    
    func testIsValidWithoutTailDecimalNumber() {
        let valid = "9."
        XCTAssertTrue(valid.isValidInputNumber())
    }
    
    func testInvalidWithAlphabet() {
        let valid = "a9"
        XCTAssertFalse(valid.isValidInputNumber())
    }
    
    func testInvalidWithTwoDots() {
        let valid = "9.0."
        XCTAssertFalse(valid.isValidInputNumber())
    }
    
    func testInvalidWithTooManyTail() {
        let valid = "9.0111"
        XCTAssertFalse(valid.isValidInputNumber())
    }
}
