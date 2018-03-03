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
import Alamofire

class MovieDetailsViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    var movie: Movie.Result?
    var trailers: Trailer?
    var youtubeId: String?
    
    //Static constants
    static let kWidthToHeightRatio = CGFloat(1.79)
    static let kContentOffset = 8
    static let kYouTubeBaseUrl = "https://www.youtube.com/watch?v="
    
    //UI elements
    lazy var posterImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / MovieDetailsViewController.kWidthToHeightRatio))
    lazy var movieTitle = UILabel()
    lazy var movieDescription = UILabel()
    lazy var watchTrailerButton = UIButton(type: UIButtonType.system)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if movie != nil {
            setupUI()
        }
    }
    
    func setupUI() {
        //Get YoutTube trailer link
        getYouTubeLink()
        
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
        
        scrollView.addSubview(watchTrailerButton)
        watchTrailerButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        watchTrailerButton.tintColor = UIColor.white
        watchTrailerButton.addTarget(self, action: #selector(MovieDetailsViewController.playTrailer), for: UIControlEvents.touchUpInside)
        watchTrailerButton.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(posterImageView.snp.centerX)
            make.centerY.equalTo(posterImageView.snp.centerY)
        }
        
        scrollView.contentSize = view.frame.size
    }
    
    func getYouTubeLink() {
        guard let movieId = movie?.id else { return }
        let youtTubeLink = MovieListViewController.kBaseUrl + String(movieId) + "/videos"
        Alamofire.request(youtTubeLink, method: .get, parameters: MovieListViewController.kParameters, encoding: URLEncoding.queryString, headers: nil).responseObject { (response: DataResponse<Trailer>) in
            if response.result.isSuccess {
                self.trailers = response.result.value
                self.youtubeId = self.trailers?.results?[0].key
            }
        }
    }
    
    @objc func playTrailer() {
        guard youtubeId != nil else {
            let alert = UIAlertController(title: "Error", message: "No trailer available", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { handler in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        //Try to open in YouTube app, if not installed - open Safari
        let youtubeUrl = NSURL(string: "youtube://\(youtubeId!)")
        if UIApplication.shared.canOpenURL(youtubeUrl! as URL) {
            UIApplication.shared.open(youtubeUrl! as URL, options: [:], completionHandler: nil  )
        } else {
            let externalYouTubeLink = URL(string: MovieDetailsViewController.kYouTubeBaseUrl + youtubeId!)
            
            guard let link = externalYouTubeLink else  { return }
            if UIApplication.shared.canOpenURL(link) {
                UIApplication.shared.open(link, options: [:], completionHandler: nil)
            }
        }
    }
}
