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
    @IBOutlet weak var loadingContainer: UIView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
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
        loadingContainer.isHidden = true
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
            
            //Movie rating and release
            ratingLabel.text = String(format: "%.1f", movie?.voteAverage ?? 0.0)
            releaseDateLabel.text = formatReleaseDate()
            
            movieDescriptionTextView.sizeToFit()
        }
    }
    
    func formatReleaseDate() -> String? {
        if let movie = self.movie {
            guard let dateComponents = movie.releaseDate?.split(separator: "-") else { return nil }
        
            let year = dateComponents[0]
            let monthAsInt = Int(dateComponents[1])
            let dayAsInt = Int(dateComponents[2])
            
            let formatter = DateFormatter()
            formatter.dateFormat = "MM"
            let monthAsText = formatter.monthSymbols[monthAsInt! - 1]
            
            let finalDate = "\(monthAsText) \(dayAsInt!), \(year)"
            
            return finalDate
        }
        
        return nil
    }
    
    func fetchYoutTubeIds() {
        guard let movieId = movie?.id else { return }
        let youtTubeIds = MovieListViewController.kBaseUrl + String(movieId) + "/videos"
        loadingContainer.isHidden = false
        
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
                self.loadingContainer.isHidden = true
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
