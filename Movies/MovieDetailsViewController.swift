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

class MovieDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDescriptionTextView: UILabel!
    @IBOutlet weak var trailersCollectionView: UICollectionView!
    
    var movie: Movie.Result?
    var trailers: Trailer?
    var youtubeTrailerIds: [String] = []
    var spinner: UIView?
    
    //Static constants
    static let kWidthToHeightRatio = CGFloat(1.79)
    static let kContentOffset = 8
    static let kYouTubeBaseUrl = "https://www.youtube.com/watch?v="
    static let kYoutTubeBaseImageUrl = "https://img.youtube.com/vi/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if movie != nil {
            //Get all trailer and teaser ids
            fetchYoutTubeIds()
            
            //Movie poster
            let imageUrl = URL(string: MovieListViewController.kBasePosterUrl + (movie?.backdropPath)!)
            posterImageView.kf.setImage(with: imageUrl)
            let posterHeight = UIScreen.main.bounds.width / MovieDetailsViewController.kWidthToHeightRatio
            let newFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: posterHeight)
            posterImageView.frame = newFrame
            posterImageView.snp.makeConstraints { (make) -> Void in
                make.height.equalTo(posterHeight)
            }
            
            //Movie title
            movieTitleLabel.text = movie?.originalTitle
            
            //Movie description
            movieDescriptionTextView.text = movie?.overview
            movieDescriptionTextView.sizeToFit()
            
            scrollView.adjustToFitContent()
        }
    }
    
    func fetchYoutTubeIds() {
        guard let movieId = movie?.id else { return }
        let youtTubeIds = MovieListViewController.kBaseUrl + String(movieId) + "/videos"
        spinner = MovieDetailsViewController.displaySpinner(onView: trailersCollectionView)
        
        Alamofire.request(youtTubeIds, method: .get, parameters: MovieListViewController.kParameters, encoding: URLEncoding.queryString, headers: nil).responseObject { (response: DataResponse<Trailer>) in
            if response.result.isSuccess {
                self.trailers = response.result.value
                if let trailers = self.trailers {
                    trailers.results?.forEach { (trailer) -> Void in
                        if let key = trailer.key {
                                self.youtubeTrailerIds.append(key)
                            }
                    }
                }
                
                if self.spinner != nil { MovieDetailsViewController.removeSpinner(spinner: self.spinner!) }
                if !self.youtubeTrailerIds.isEmpty {
                    self.setupTrailerSection()
                }
            }
        }
    }
    
    func setupTrailerSection () {
        trailersCollectionView.delegate = self
        trailersCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return youtubeTrailerIds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellview = collectionView.dequeueReusableCell(withReuseIdentifier: "trailerCellView", for: indexPath) as! TrailerCollectionViewCell
        let videoId = youtubeTrailerIds[indexPath.row]
        let thumbnailLink = MovieDetailsViewController.kYoutTubeBaseImageUrl + videoId + "/0.jpg"
        cellview.setThumbnail(url: thumbnailLink)
        
        return cellview
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let videoId = youtubeTrailerIds[indexPath.row]
        
        //Try to open in YouTube app, if not installed - open Safari
        let youtubeUrl = NSURL(string: "youtube://\(videoId)")
        if UIApplication.shared.canOpenURL(youtubeUrl! as URL) {
            UIApplication.shared.open(youtubeUrl! as URL, options: [:], completionHandler: nil  )
        } else {
            let externalYouTubeLink = URL(string: MovieDetailsViewController.kYouTubeBaseUrl + videoId)

            guard let link = externalYouTubeLink else  { return }
            if UIApplication.shared.canOpenURL(link) {
                UIApplication.shared.open(link, options: [:], completionHandler: nil)
            }
        }
    }
}

extension UIScrollView {
    func adjustToFitContent() {
        var contentRect = CGRect.zero
        for view in self.subviews {
            contentRect = contentRect.union(view.frame)
        }
        self.contentSize = contentRect.size
    }
}

extension UIViewController {
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        
        //If the width is bigger than screen width => Adjust it
        if spinnerView.frame.size.width > UIScreen.main.bounds.width {
            var spinnerFrame = spinnerView.frame
            spinnerFrame.size.height = onView.bounds.height
            spinnerFrame.size.width = UIScreen.main.bounds.width
            
            spinnerView.frame = spinnerFrame
        }
        
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.25)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        return spinnerView
    }
    
    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}
