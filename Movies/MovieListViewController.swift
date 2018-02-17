//
//  MovieListViewController.swift
//  Movies
//
//  Created by Sheroz Nazhmudinov on 2/10/18.
//  Copyright © 2018 Sheroz Nazhmudinov. All rights reserved.
//

import UIKit
import Alamofire

class MovieListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    static let kImageWidth: CGFloat = 500
    static let kImageHeight: CGFloat = 750
    
    static let kBaseUrl = "https://api.themoviedb.org/3/movie/"
    static let kBasePosterUrl = "http://image.tmdb.org/t/p/w500//"
    
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    let categories = [
        "Popular": "popular",
        "Now playing": "now_playing",
        "Top rated": "top_rated",
        "Upcoming": "upcoming"
    ]
    
    var selectedCategory: String?
    var moviesContainer: Movie?
    let parameters: Parameters = ["api_key": "7529be3d3e7c986c84fdac10f7eb25c4"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let category = self.selectedCategory {
            self.title = category
            let categoryParam = categories[category]
            
            guard let param = categoryParam else { return }
            let url = MovieListViewController.kBaseUrl + param
            
            Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: nil).responseJSON { response in
                
                if response.result.isSuccess {
                    do {
                        self.moviesContainer = try JSONDecoder().decode(Movie.self, from: response.data!)
                        self.setupMovies()
                    } catch {
                        print("Error parsing json")
                    }
                }
            }
        }
    }
    
    func setupMovies() {
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return moviesContainer?.results.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCellView", for: indexPath) as! MovieCollectionCellView
        let posterPath = moviesContainer?.results[indexPath.row].posterPath
        let fullPosterURL = URL(string: MovieListViewController.kBasePosterUrl + posterPath!)!
        cell.setPoster(url: fullPosterURL)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let requiredWidth = UIScreen.main.bounds.width / 2
        let requiredHeight = (requiredWidth * MovieListViewController.kImageHeight) / MovieListViewController.kImageWidth
        
        return CGSize(width: requiredWidth, height: requiredHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movies = moviesContainer?.results else { return }
        let selectedMovie = movies[indexPath.row]
        
        if let movieDetailsViewController = storyboard?.instantiateViewController(withIdentifier: "movieDetails") as?
            MovieDetailsViewController {
            movieDetailsViewController.movie = selectedMovie
            navigationController?.show(movieDetailsViewController, sender: self)
        }
    }
}
