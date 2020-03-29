//
//  CurrencyTableViewCell.swift
//  MoblieDeveloperChallenge
//
//  Created by Kory on 2020/3/26.
//  Copyright © 2020 CHIHYEN. All rights reserved.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {
    
    private lazy var currencyLabel: UILabel = {
       let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 30, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var amountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 24, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    private func setupView() {
        contentView.addSubview(currencyLabel)
        contentView.addSubview(amountLabel)
        NSLayoutConstraint.activate([
            currencyLabel.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            currencyLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            currencyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            currencyLabel.widthAnchor.constraint(equalToConstant: 90)
        ])
        
        NSLayoutConstraint.activate([
            amountLabel.leadingAnchor.constraint(equalTo: currencyLabel.trailingAnchor, constant: 16),
            amountLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            amountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            amountLabel.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    func updateContent(for currency: String, amount: String?) {
        currencyLabel.text = currency
        amountLabel.text = amount
    }
}

extension CurrencyTableViewCell {
    static var cellIdentifier: String {
        String(describing: self)
    }
}
