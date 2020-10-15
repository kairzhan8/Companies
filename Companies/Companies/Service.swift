//
//  Service.swift
//  Companies
//
//  Created by Kairzhan Kural on 10/15/20.
//  Copyright © 2020 Kairzhan Kural. All rights reserved.
//

import Foundation

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
                jsonCompanies.forEach { (jsonCompany) in
                    print(jsonCompany.name)
                    
                    jsonCompany.employees?.forEach({ (jsonEmployee) in
                        print("  \(jsonEmployee.name)")
                    })
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
