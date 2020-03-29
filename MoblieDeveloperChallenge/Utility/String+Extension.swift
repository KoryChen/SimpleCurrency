//
//  String+Extension.swift
//  MoblieDeveloperChallenge
//
//  Created by Kory on 2020/3/27.
//  Copyright © 2020 CHIHYEN. All rights reserved.
//

import Foundation

extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    func isValidInputNumber() -> Bool {
        guard self.isEmpty || (Decimal(string: self) != nil) else {
            return false
        }
        
        let numberOfDots = self.components(separatedBy: ".").count - 1
        guard numberOfDots <= 1 else {
            return false
        }
        
        let numberOfDecimalDigits: Int
        if let dotIndex = self.firstIndex(of: ".") {
            numberOfDecimalDigits = self.distance(from: dotIndex, to: self.endIndex) - 1
        } else {
            numberOfDecimalDigits = 0
        }
        
        return numberOfDecimalDigits <= 2
    }
}
