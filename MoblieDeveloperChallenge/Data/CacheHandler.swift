//
//  CacheHandler.swift
//  MoblieDeveloperChallenge
//
//  Created by Kory on 2020/3/26.
//  Copyright © 2020 CHIHYEN. All rights reserved.
//

import Foundation

class CacheHandler<T: Codable> {
    let filename: String
    init(with filename: String) {
        self.filename = filename
    }
    
    func save(data: [T]) {
        let path = getDocumentsDirectory().appendingPathComponent(filename)
        do {
            let data = try JSONEncoder().encode(data)
            try data.write(to: path, options: .atomic)
        } catch {
            //TODO : handle error
        }
    }
    
    func load() throws -> [T]? {
        let fileURL = getDocumentsDirectory().appendingPathComponent(filename)
        guard FileManager.default.fileExists(atPath: fileURL.path),
            let data = FileManager.default.contents(atPath: fileURL.path) else {
                throw GeneralError.notFound
        }
        
        return try JSONDecoder().decode([T].self, from: data)
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
