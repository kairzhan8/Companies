//
//  CompanyCell.swift
//  Companies
//
//  Created by Kairzhan Kural on 10/10/20.
//  Copyright © 2020 Kairzhan Kural. All rights reserved.
//

import UIKit

class CompanyCell: UITableViewCell {
    
    var company: Company? {
        didSet {
            nameFoundedDateLabel.text = company?.name
            
            if let companyImage = company?.imageData {
                companyImageView.image = UIImage(data: companyImage)
            }
            
            if let name = company?.name, let founded = company?.founded {
                let customDate = DateFormatter()
                customDate.dateFormat = "MMM dd, yyyy"
                let foundedDateString = customDate.string(from: founded)
                nameFoundedDateLabel.text = "\(name) - Founded: \(foundedDateString)"
            } else {
                nameFoundedDateLabel.text = "\(company?.name ?? "")  \(company?.numberOfEmloyees ?? 0)"
            }
        }
    }
    
    let companyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "select_photo_empty")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.darkBlue.cgColor
        imageView.layer.borderWidth = 1
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameFoundedDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Company name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .tealColor
        
        addSubview(companyImageView)
              companyImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16 ).isActive = true
              companyImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
              companyImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
              companyImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        addSubview(nameFoundedDateLabel)
        nameFoundedDateLabel.leftAnchor.constraint(equalTo: companyImageView.rightAnchor, constant: 8).isActive = true
        nameFoundedDateLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nameFoundedDateLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        nameFoundedDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
