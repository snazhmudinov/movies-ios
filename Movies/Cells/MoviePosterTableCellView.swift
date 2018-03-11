//
//  MoviePosterTableCellView.swift
//  Movies
//
//  Created by Sheroz Nazhmudinov on 3/11/18.
//  Copyright © 2018 Sheroz Nazhmudinov. All rights reserved.
//

import UIKit

class MoviePosterTableCellView: UITableViewCell {
    
    @IBOutlet weak var moviePoster: UIImageView!
    
    func setPoster(posterUrl: String?) {
        guard let poster = posterUrl else { return }
        let url = URL(string: poster)
        
        moviePoster.kf.setImage(with: url)
    }
}
