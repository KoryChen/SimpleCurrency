//
//  CurrencyViewController.swift
//  MoblieDeveloperChallenge
//
//  Created by Kory on 2020/3/26.
//  Copyright © 2020 CHIHYEN. All rights reserved.
//

import UIKit

class CurrencyViewController: UIViewController {
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter number"
        textField.textAlignment = .right
        textField.keyboardType = .decimalPad
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        textField.font = .systemFont(ofSize: 36, weight: .medium)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.dataSource = self
        table.delegate  = self
        table.keyboardDismissMode = .onDrag
        table.register(CurrencyTableViewCell.self, forCellReuseIdentifier: CurrencyTableViewCell.cellIdentifier)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    lazy var currencyButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.setTitle(self.viewModel.selectedKey, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let viewModel: CurrencyViewModel
    init(with viewModel: CurrencyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        viewModel.delegate = self
        viewModel.loadData()
    }
    
    private func setupViews() {
        view.addSubview(textField)
        view.addSubview(currencyButton)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
          textField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32),
          textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
          textField.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        NSLayoutConstraint.activate([
            currencyButton.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            currencyButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 10),
            currencyButton.heightAnchor.constraint(equalToConstant: 30),
            currencyButton.widthAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: currencyButton.bottomAnchor, constant: 20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    @objc
    private func buttonClicked(_ sender: UIButton) {
        let picker =
            PickerViewController(
                list: viewModel.allKeys(),
                default: viewModel.selectedKey) {
                    [unowned self] (key) in
                    self.viewModel.updateSelected(key)
        }
        picker.modalPresentationStyle = .overFullScreen
        present(picker, animated: true)
    }
    
    @objc
    private func textFieldDidChange(_ sender: UITextField) {
        tableView.reloadData()
    }
}

extension CurrencyViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text,
            let r = Range(range, in: oldText) else {
            return true
        }

        let newText = oldText.replacingCharacters(in: r, with: string)
        return newText.isValidInputNumber()
    }
    
}

extension CurrencyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
}

extension CurrencyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyTableViewCell.cellIdentifier, for: indexPath) as! CurrencyTableViewCell
        let tuple = viewModel.tuple(at: indexPath, input: textField.text)
        cell.updateContent(for: tuple.name, amount: tuple.amount)
        return cell
    }
}

extension CurrencyViewController: CurrencyViewModelDelegate {
    func viewModelDidUpdateData(_ viewModel: CurrencyViewModel) {
        tableView.reloadData()
    }
    
    func viewModelInputDidChange(_ viewModel: CurrencyViewModel) {
        tableView.reloadData()
    }
    
    func viewModel(_ viewModel: CurrencyViewModel, fetchFailure error: Error) {
        let alert = UIAlertController(title: "Alert", message: "fetch API Failure", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    func viewModel(_ viewModel: CurrencyViewModel, selectedKeyChanged key: String) {
        currencyButton.setTitle(key, for: .normal)
        tableView.reloadData()
    }
}
