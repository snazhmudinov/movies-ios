//
//  MovieDetailsViewController.swift
//  Movies
//
//  Created by Sheroz Nazhmudinov on 2/17/18.
//  Copyright © 2018 Sheroz Nazhmudinov. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class MovieDetailsViewController: UIViewController {

    static let kWidthToHeightRatio = CGFloat(1.79)
    
    var movie: Result?
    lazy var posterImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / MovieDetailsViewController.kWidthToHeightRatio))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if movie != nil {
            setupUI()
        }
    }
    
    func setupUI() {
        //Movie poster
        self.view.addSubview(posterImageView)
        let imageUrl = URL(string: MovieListViewController.kBasePosterUrl + (movie?.backdropPath)!)
        posterImageView.kf.setImage(with: imageUrl)
        
        //Movie title
        
    }
}
