//
//  MovieListViewController.swift
//  Movies
//
//  Created by Sheroz Nazhmudinov on 2/10/18.
//  Copyright © 2018 Sheroz Nazhmudinov. All rights reserved.
//

import UIKit
import Alamofire

class MovieListViewController: UIViewController {
    
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
    
    var movies: [Movie]?
    
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
                        self.movies = try JSONDecoder().decode([Movie].self, from: response.data!)
                    } catch {
                        print("Error parsing json")
                    }
                }
            }
        }
    }
}
