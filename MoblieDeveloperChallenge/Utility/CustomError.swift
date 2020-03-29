//
//  CustomError.swift
//  MoblieDeveloperChallenge
//
//  Created by Kory on 2020/3/26.
//  Copyright © 2020 CHIHYEN. All rights reserved.
//

import Foundation

enum GeneralError: Error {
    case notFound
    case formatIncorrect
}

enum APIError: Error {
    case nilData
}
