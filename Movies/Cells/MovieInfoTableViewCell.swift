//
//  MovieInfoTableViewCell.swift
//  Movies
//
//  Created by Sheroz Nazhmudinov on 3/11/18.
//  Copyright © 2018 Sheroz Nazhmudinov. All rights reserved.
//

import UIKit

class MovieInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieInfo: UILabel!
    
    func setInfo(info: String?) {
        guard let string = info else { return }
        movieInfo.text = string
    }
}
