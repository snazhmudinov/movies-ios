//
//  TrailerCollectionViewCell.swift
//  Movies
//
//  Created by Sheroz Nazhmudinov on 3/4/18.
//  Copyright © 2018 Sheroz Nazhmudinov. All rights reserved.
//

import UIKit

class TrailerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var youtubeThumbnail: UIImageView!
    
    func setThumbnail(url: String) {
        youtubeThumbnail.kf.setImage(with: URL(string: url))
    }
}
