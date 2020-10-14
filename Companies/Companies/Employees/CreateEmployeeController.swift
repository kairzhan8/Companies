//
//  CreateEmployeeController.swift
//  Companies
//
//  Created by Kairzhan Kural on 10/12/20.
//  Copyright © 2020 Kairzhan Kural. All rights reserved.
//

import UIKit

protocol CreateEmployeeControllerDelegate {
    func didAddEmployee(employee: Employee)
}

class CreateEmployeeController: UIViewController {
    
    var delegate: CreateEmployeeControllerDelegate?
    var company: Company?
    
    let nameLabel: UILabel = {
           let label = UILabel()
           label.text = "Name"
           label.translatesAutoresizingMaskIntoConstraints = false
           return label
       }()
       
       let nameTextField: UITextField = {
           let textField = UITextField()
           textField.placeholder = "Enter name"
           textField.translatesAutoresizingMaskIntoConstraints = false
           return textField
       }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .darkBlue
        setupCancelButton()
        setupNavigationStyle()
        navigationItem.title = "Create Employee"
        
        _ = setupLightBlueBackgroundView(height: 50)
        setupUI()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
    }
    
    @objc private func handleSave() {
        print("Trying to add employee")
        guard let employeeName = nameTextField.text else { return }
        guard let company = company  else { return }
        let tuple = CoreDataManager.shared.createEmployee(employeeName: employeeName, company: company)
        if let error = tuple.1 {
            print(error)
        } else {
            dismiss(animated: true) {
                self.delegate?.didAddEmployee(employee: tuple.0!)
            }
        }
    }
    
    private func setupUI() {
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(nameTextField)
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true
        nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor).isActive = true
        nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
    }
}
