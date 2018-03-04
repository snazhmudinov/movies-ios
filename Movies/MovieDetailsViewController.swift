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
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDescriptionTextView: UILabel!
    
    
    var movie: Movie.Result?
    var trailers: Trailer?
    var youtubeId: String?
    
    //Static constants
    static let kWidthToHeightRatio = CGFloat(1.79)
    static let kContentOffset = 8
    static let kYouTubeBaseUrl = "https://www.youtube.com/watch?v="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if movie != nil {
            //Get YoutTube trailer link
            getYouTubeLink()
            
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
    
    func getYouTubeLink() {
        guard let movieId = movie?.id else { return }
        let youtTubeLink = MovieListViewController.kBaseUrl + String(movieId) + "/videos"
        Alamofire.request(youtTubeLink, method: .get, parameters: MovieListViewController.kParameters, encoding: URLEncoding.queryString, headers: nil).responseObject { (response: DataResponse<Trailer>) in
            if response.result.isSuccess {
                self.trailers = response.result.value
                print("Number of trailers: \(self.trailers?.results?.count ?? 0)")
            }
        }
    }
    
//    @objc func playTrailer() {
//        guard youtubeId != nil else {
//            let alert = UIAlertController(title: "Error", message: "No trailer available", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "OK", style: .default) { handler in
//                alert.dismiss(animated: true, completion: nil)
//            }
//            alert.addAction(okAction)
//            self.present(alert, animated: true, completion: nil)
//            return
//        }
//
//        //Try to open in YouTube app, if not installed - open Safari
//        let youtubeUrl = NSURL(string: "youtube://\(youtubeId!)")
//        if UIApplication.shared.canOpenURL(youtubeUrl! as URL) {
//            UIApplication.shared.open(youtubeUrl! as URL, options: [:], completionHandler: nil  )
//        } else {
//            let externalYouTubeLink = URL(string: MovieDetailsViewController.kYouTubeBaseUrl + youtubeId!)
//
//            guard let link = externalYouTubeLink else  { return }
//            if UIApplication.shared.canOpenURL(link) {
//                UIApplication.shared.open(link, options: [:], completionHandler: nil)
//            }
//        }
//    }
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
