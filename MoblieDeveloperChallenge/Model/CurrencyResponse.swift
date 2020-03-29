//
//  CurrencyResponse.swift
//  MoblieDeveloperChallenge
//
//  Created by Kory on 2020/3/26.
//  Copyright © 2020 CHIHYEN. All rights reserved.
//

import Foundation

struct CurrencyResponse: Codable {
    let timestamp: Int32
    let quotes: [String: Decimal]
}
