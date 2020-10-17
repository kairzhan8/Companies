//
//  EmployeesController.swift
//  Companies
//
//  Created by Kairzhan Kural on 10/12/20.
//  Copyright © 2020 Kairzhan Kural. All rights reserved.
//

import UIKit
import CoreData

class IndendedLabel: UILabel {
    override func drawText(in rect: CGRect) {
        let padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0)
        let rectangle = bounds.inset(by: padding)
        super.drawText(in: rectangle)
    }
}

class EmployeesController: UITableViewController, CreateEmployeeControllerDelegate {
    
    func didAddEmployee(employee: Employee) {
        guard let section = employeeTypes.firstIndex(of: employee.type!) else { return }
        let row = allEmployees[section].count
        let insertionIndexPath = IndexPath(row: row, section: section)
        allEmployees[section].append(employee)
        tableView.insertRows(at: [insertionIndexPath], with: .fade)
    }
    
    
    var company: Company?
    var allEmployees = [[Employee]]()
    
    var employeeTypes = [
        EmployeeType.Executive.rawValue,
        EmployeeType.SeniorManagement.rawValue,
        EmployeeType.Staff.rawValue
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = company?.name
    }
    
    private func fetchEmployees() {
        print("Trying to fetch employees from core data")
        guard let employees = company?.employees?.allObjects as? [Employee] else { return }
        allEmployees = []
        
        employeeTypes.forEach { (employeeType) in
            allEmployees.append(
                employees.filter{$0.type == employeeType}
            )
        }
    }
    
    let cellID = "cellllllid"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchEmployees()
        
        view.backgroundColor = .darkBlue
        
        setupPlusButtonInNavBar(selector: #selector(handleAdd))
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        allEmployees.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = IndendedLabel()
        label.backgroundColor = .lightBlue
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .darkBlue
        label.text = employeeTypes[section]
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        50
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allEmployees[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
         
        let employee = allEmployees[indexPath.section][indexPath.row]
        cell.textLabel?.text = employee.fullName
        if let birthday = employee.employeeInformation?.birthday {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            cell.textLabel?.text = "\(employee.fullName ?? "")     \(dateFormatter.string(from: birthday))"
        }
//        if let taxId = employee.employeeInformation?.taxId {
//            cell.textLabel?.text = "\(employee.name ?? "")      \(taxId)"
//        }
        
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .tealColor
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        
        return cell
    }
    
    @objc private func handleAdd() {
        print("Trying to to add new employee")
        let createEmployeeController = CreateEmployeeController()
        createEmployeeController.delegate = self
        createEmployeeController.company = company
        let navController = CustomNavigationController(rootViewController: createEmployeeController)
        navController.modalPresentationStyle = .currentContext
        present(navController, animated: true, completion: nil)
    }
}
