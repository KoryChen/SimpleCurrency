//
//  DataCenterTests.swift
//  MoblieDeveloperChallengeTests
//
//  Created by Kory on 2020/3/27.
//  Copyright © 2020 CHIHYEN. All rights reserved.
//

import XCTest
@testable import MoblieDeveloperChallenge

class DataCenterTests: XCTestCase {
    class mockHandler: CacheHandler<CurrencyModel> {
        override init(with filename: String = "dataCenterTest.dat") {
            super.init(with: filename)
        }
     
        override func load() throws -> [CurrencyModel]? {
            [CurrencyModel(name: "JPY", rate: Decimal(90000.00)),
             CurrencyModel(name: "USD", rate: Decimal(1000.00)),
             CurrencyModel(name: "NTD", rate: Decimal(30000.00))]
        }
    }
   
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    override func tearDown() {
        let file = getDocumentsDirectory().appendingPathComponent("dataCenterTest.dat").path
        if FileManager.default.fileExists(atPath: file) {
            try? FileManager.default.removeItem(atPath: file)
        }
    }

    func testEmptyData() {
        let emptyhandler = CacheHandler<CurrencyModel>(with: "empty.dat")
        let dataCenter = DataCenter(handler: emptyhandler)
        XCTAssertTrue(dataCenter.fetchCurrencies().isEmpty)
    }
    
    func testFetchCurrency() {
        let dataCenter = DataCenter(handler: mockHandler())
        XCTAssertFalse(dataCenter.fetchCurrencies().isEmpty)
    }
    
    func testUpdateCurrency() {
        let dataCenter = DataCenter(handler: mockHandler())
        let new = [CurrencyModel(name: "JPY", rate: Decimal(90000.00)),
                   CurrencyModel(name: "AUS", rate: Decimal(30000.00))]
        dataCenter.update(new)
        XCTAssertTrue(dataCenter.fetchCurrencies().count == 2)
        XCTAssertEqual(dataCenter.fetchCurrencies().first?.name, "AUS")
    }
    
    func testResponseUpdate() {
        let mockResponse = CurrencyResponse(
            timestamp: 1585240445,
            quotes: [
                "USDAED":Decimal(3.67295),
                "USDAFN":Decimal(76.802101)]
        )
        let dataCenter = DataCenter(handler: mockHandler())
        dataCenter.update(with: mockResponse)
        XCTAssertTrue(dataCenter.fetchCurrencies().count == 2)
        XCTAssertEqual(dataCenter.fetchCurrencies().first?.name, "AED")
    }
}
