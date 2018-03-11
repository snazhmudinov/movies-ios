//
//  MovieCollectionCellView.swift
//  Movies
//
//  Created by Sheroz Nazhmudinov on 2/13/18.
//  Copyright © 2018 Sheroz Nazhmudinov. All rights reserved.
//

import UIKit
import Kingfisher

class MovieCollectionCellView: UICollectionViewCell {
    
    @IBOutlet weak var moviePoster: UIImageView!
    
    func setPoster(url: URL) {
        moviePoster.kf.setImage(with: url)
    }
}
