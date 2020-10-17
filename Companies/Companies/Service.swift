//
//  Service.swift
//  Companies
//
//  Created by Kairzhan Kural on 10/15/20.
//  Copyright © 2020 Kairzhan Kural. All rights reserved.
//

import Foundation
import CoreData

struct Service {
    static let shared = Service()
    
    let stringUrl = "http://api.letsbuildthatapp.com/intermediate_training/companies"
    
    func fetchCompanies() {
        let jsonDecoder = JSONDecoder()
        guard let url = URL(string: stringUrl) else { return }
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let err = err {
                print("Failed when fetch from api", err)
            }
            guard let data = data else { return }
            do {
                let jsonCompanies = try jsonDecoder.decode([JSONCompany].self, from: data)
                let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                privateContext.parent = CoreDataManager.shared.persistantContainer.viewContext
                jsonCompanies.forEach { (jsonCompany) in
                    print(jsonCompany.name)
                    let company = Company(context: privateContext)
                    company.name = jsonCompany.name
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    let jsonFounded = dateFormatter.date(from: jsonCompany.founded)
                    company.founded = jsonFounded
                    jsonCompany.employees?.forEach({ (jsonEmployee) in
                        print("  \(jsonEmployee.name)")
                        let employee = Employee(context: privateContext)
                        employee.name = jsonEmployee.name
                        employee.type = jsonEmployee.type
                        let employeeInformation = EmployeeInformation(context: privateContext)
                        let employeeBirthday = dateFormatter.date(from: jsonEmployee.birthday)
                        employeeInformation.birthday = employeeBirthday
                        employee.employeeInformation = employeeInformation
                        employee.company = company
                    })
                    
                    do {
                        try privateContext.save()
                        try privateContext.parent?.save()
                        
                    } catch let err {
                        print("Failed to save", err)
                    }
                }
            } catch let err {
                print("Failed to decode json", err)
            }
        }.resume()
        
    }
}

struct JSONCompany: Decodable {
    let name: String
    let founded: String
    var employees: [JSONEmployee]?
}

struct JSONEmployee: Decodable {
    let name: String
    let type: String
    let birthday: String
}
