//
//  CategoryViewCell.swift
//  Movies
//
//  Created by Sheroz Nazhmudinov on 2/10/18.
//  Copyright © 2018 Sheroz Nazhmudinov. All rights reserved.
//

import UIKit

class CategoryViewCell: UITableViewCell {
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    func setCategory(category: String) {
        categoryLabel.text = category
    }
}
