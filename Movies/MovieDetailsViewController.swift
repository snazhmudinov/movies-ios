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

    @IBOutlet weak var scrollView: UIScrollView!
    var movie: Result?
    
    //Static constants
    static let kWidthToHeightRatio = CGFloat(1.79)
    static let kContentOffset = 8
    
    //UI elements
    lazy var posterImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / MovieDetailsViewController.kWidthToHeightRatio))
    lazy var movieTitle = UILabel()
    lazy var movieDescription = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if movie != nil {
            setupUI()
        }
    }
    
    func setupUI() {
        //Movie poster
        scrollView.addSubview(posterImageView)
        let imageUrl = URL(string: MovieListViewController.kBasePosterUrl + (movie?.backdropPath)!)
        posterImageView.kf.setImage(with: imageUrl)
        
        //Movie title
        let titleLabel = UILabel()
        titleLabel.text = "Title".uppercased()
        titleLabel.textColor = UIColor.gray
        titleLabel.font = UIFont.boldSystemFont(ofSize: 12)
        scrollView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) -> Void in
           make.top.equalTo(posterImageView.snp.bottom).offset(MovieDetailsViewController.kContentOffset)
           make.left.equalTo(view.snp.left).offset(MovieDetailsViewController.kContentOffset)
        }
        
        movieTitle.text = movie?.originalTitle
        scrollView.addSubview(movieTitle)
        movieTitle.numberOfLines = 0
        movieTitle.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(titleLabel.snp.bottom).offset(MovieDetailsViewController.kContentOffset)
            make.right.equalTo(view.snp.right).inset(MovieDetailsViewController.kContentOffset)
            make.left.equalTo(view.snp.left).offset(MovieDetailsViewController.kContentOffset)
        }
        
        //Movie description
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Description".uppercased()
        descriptionLabel.textColor = UIColor.gray
        descriptionLabel.font = UIFont.boldSystemFont(ofSize: 12)
        scrollView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(movieTitle.snp.bottom).offset(MovieDetailsViewController.kContentOffset)
            make.left.equalTo(view.snp.left).offset(MovieDetailsViewController.kContentOffset)
        }
        
        movieDescription.text = movie?.overview
        scrollView.addSubview(movieDescription)
        movieDescription.numberOfLines = 0
        movieDescription.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(MovieDetailsViewController.kContentOffset)
            make.right.equalTo(view.snp.right).inset(MovieDetailsViewController.kContentOffset)
            make.left.equalTo(view.snp.left).offset(MovieDetailsViewController.kContentOffset)
            
        }
        
        scrollView.contentSize = view.frame.size
    }
}