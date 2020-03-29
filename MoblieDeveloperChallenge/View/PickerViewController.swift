//
//  PickerViewController.swift
//  MoblieDeveloperChallenge
//
//  Created by Kory on 2020/3/27.
//  Copyright © 2020 CHIHYEN. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController {
    lazy var picker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.backgroundColor = .lightGray
        picker.delegate = self
        picker.dataSource = self
        return picker
    }()
    
    lazy var bottomView: UIView = {
        let bottomView = UIView()
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.backgroundColor = .lightGray
        return bottomView
    }()
    
    lazy var controlView: UIView = {
        let controlView = UIView()
        controlView.translatesAutoresizingMaskIntoConstraints = false
        controlView.backgroundColor = .lightGray
        return controlView
    }()
    
    lazy var doneButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("done", for: .normal)
        button.setTitleColor(.lightText, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 24, weight: .regular)
        button.addTarget(self, action: #selector(doneButtionClicked(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let list: [String]
    var selectedKey: String
    var didSelectedHandler: ((String)->Void)?
    
    init(list: [String],
         default key: String,
         completionHandler: (((String)->Void))?) {
        self.list = list
        self.selectedKey = key
        self.didSelectedHandler = completionHandler
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(picker)
        view.addSubview(controlView)
        controlView.addSubview(doneButton)
        view.addSubview(bottomView)

        NSLayoutConstraint.activate([
            picker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            picker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            picker.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            controlView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            controlView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            controlView.bottomAnchor.constraint(equalTo: picker.topAnchor),
            controlView.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        NSLayoutConstraint.activate([
            doneButton.trailingAnchor.constraint(equalTo: controlView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 32),
            doneButton.widthAnchor.constraint(equalToConstant: 60),
            doneButton.topAnchor.constraint(equalTo: controlView.topAnchor, constant: 6)
        ])
        
        NSLayoutConstraint.activate([
            bottomView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        if let index = list.firstIndex(of: selectedKey) {        
            picker.selectRow(index, inComponent: 0, animated: true)
        }
    }

    @objc
    private func doneButtionClicked(_ sender: UIButton) {
        didSelectedHandler?(selectedKey)
        dismiss(animated: true)
    }
}

extension PickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        list.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        list[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedKey = list[row]
    }
}
