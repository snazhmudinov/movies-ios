//
//  MovieListViewController.swift
//  Movies
//
//  Created by Sheroz Nazhmudinov on 2/10/18.
//  Copyright © 2018 Sheroz Nazhmudinov. All rights reserved.
//

import UIKit
import Alamofire

class MovieListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    
    let categories = [
        "Popular": "popular",
        "Now playing": "now_playing",
        "Top rated": "top_rated",
        "Upcoming": "upcoming"
    ]
    
    var selectedCategory: String?
    let parameters: Parameters = ["api_key": "7529be3d3e7c986c84fdac10f7eb25c4"]
    
    var baseUrl = "https://api.themoviedb.org/3/movie/"
    var basePosterUrl = "http://image.tmdb.org/t/p/w500//"
    
    var moviesContainer: MovieContainer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let category = self.selectedCategory {
            self.title = category
            let categoryParam = categories[category]
            
            guard let param = categoryParam else { return }
            let url = baseUrl + param
            
            Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: nil).responseJSON { response in
                
                if response.result.isSuccess {
                    do {
                        self.moviesContainer = try JSONDecoder().decode(MovieContainer.self, from: response.data!)
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
        let posterPath = moviesContainer?.results[indexPath.row].backdropPath
        let fullPosterURL = URL(string: basePosterUrl + posterPath!)!
        cell.setPoster(url: fullPosterURL)
        
        return cell
    }
}
