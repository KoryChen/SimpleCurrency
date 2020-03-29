//
//  DataCenter.swift
//  MoblieDeveloperChallenge
//
//  Created by Kory on 2020/3/26.
//  Copyright © 2020 CHIHYEN. All rights reserved.
//

import Foundation

internal class DataCenter {
    static let dataUpdateKey = NSNotification.Name("dataUpdate")
    static let shared = DataCenter()
    private var models: [CurrencyModel] = []
    private let queue = DispatchQueue(label: "currency.queue", attributes: .concurrent)
    private(set) var dataTime: Date?
    
    let handler: CacheHandler<CurrencyModel>
    init(handler: CacheHandler<CurrencyModel> = CacheHandler<CurrencyModel>(with: "currency.dat")) {
        self.handler = handler
        dataTime = UserDefaults.standard.object(forKey: "updateTime") as? Date
        setupData()
    }
    
    private func setupData() {
        guard let data = try? handler.load() else {
            return
        }
        models = data
    }
    
    func fetchCurrencies() -> [CurrencyModel] {
        var copyModels: [CurrencyModel]!
        queue.sync {
            copyModels = models.sorted{$0.name < $1.name}
        }
        return copyModels
    }
    
    func update(with response: CurrencyResponse) {
        UserDefaults.standard.set(Date(), forKey: "updateTime")
        let models = response.quotes.map{ CurrencyModel(name: $0.key.deletingPrefix("USD"), rate: $0.value) }
        update(models)
    }
    
    func update(_ models: [CurrencyModel]) {
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else {
                return
            }
            self.models = models
            self.handler.save(data: self.models)
            DispatchQueue.main.async {
                NotificationCenter.default.post(
                    name: DataCenter.dataUpdateKey,
                    object: self)
            }
        }
    }
}
