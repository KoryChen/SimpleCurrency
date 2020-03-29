//
//  CurrencyViewModel.swift
//  MoblieDeveloperChallenge
//
//  Created by Kory on 2020/3/26.
//  Copyright © 2020 CHIHYEN. All rights reserved.
//

import Foundation

protocol CurrencyViewModelDelegate: class {
    func viewModel(_ viewModel: CurrencyViewModel, fetchFailure error: Error)
    func viewModelDidUpdateData(_ viewModel: CurrencyViewModel)
    func viewModelInputDidChange(_ viewModel: CurrencyViewModel)
    func viewModel(_ viewModel: CurrencyViewModel, selectedKeyChanged key: String)
}

class CurrencyViewModel {
    weak var delegate: CurrencyViewModelDelegate?
    
    lazy var format: NumberFormatter = {
        let format = NumberFormatter()
        format.maximumFractionDigits = 6
        format.minimumFractionDigits = 2
        return format
    }()
    
    private var currencies: [CurrencyModel] = []
    private var selectedModel: CurrencyModel?
    private(set) var selectedKey: String {
        didSet {
            selectedModel = currencies.first { $0.name == selectedKey }
        }
    }
    
    unowned let dataCenter: DataCenter
    let client: APIClient
    init(with client: APIClient = APIClient(session: URLSession.shared),
         dataSource: DataCenter = DataCenter.shared) {
        self.client = client
        self.dataCenter = dataSource
        self.selectedKey = UserDefaults.standard.string(forKey: "selectedKey") ?? "USD"
        commonInit()
    }
    
    private func commonInit() {
        currencies = dataCenter.fetchCurrencies()
        selectedModel = currencies.first { $0.name == selectedKey }
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(dataUpdated(_:)),
            name: DataCenter.dataUpdateKey,
            object: nil)
    }
    
    @objc
    private func dataUpdated(_ note: Notification) {
        currencies = dataCenter.fetchCurrencies()
        delegate?.viewModelDidUpdateData(self)
    }
    
    private func convertInput(with text: String?) -> Decimal {
        if let text = text,
            let number = Decimal(string: text) {
            return number
        } else {
            return 1
        }
    }
    
    func allKeys() -> [String] {
        currencies.map{ $0.name }
    }
    
    func numberOfRows() -> Int {
        currencies.count
    }
    
    func updateSelected(_ key: String) {
        self.selectedKey = key
        UserDefaults.standard.setValue(key, forKey: "selectedKey")
        delegate?.viewModel(self, selectedKeyChanged: key)
    }
    
    func tuple(at indexPath: IndexPath, input: String?)
        -> (name: String, amount: String?) {
        guard indexPath.row < currencies.count else {
            fatalError("shouldn't be here.")
        }
        
        let model = currencies[indexPath.row]
        let amount = model.rate / (selectedModel?.rate ?? 1) * convertInput(with: input)
        return (model.name, format.string(for: amount))
    }
    
    func loadData() {
        guard shouldUpdateCurrencyList() else {
            return
        }
        client.fetchLiveCurrencies { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.dataCenter.update(with: response)
            case .failure(let error):
                self.delegate?.viewModel(self, fetchFailure: error)
            }
        }
    }
    
    func shouldUpdateCurrencyList() -> Bool {
        guard var dataDate = dataCenter.dataTime else {
            return true
        }
        //to limit 30 minutes for calling API.
        dataDate.addTimeInterval(1800)
        return Date() > dataDate
    }
}
