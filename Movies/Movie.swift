//
//  Movie.swift
//  Movies
//
//  Created by Sheroz Nazhmudinov on 2/11/18.
//  Copyright © 2018 Sheroz Nazhmudinov. All rights reserved.
//

import Foundation

struct Movie: Codable {
    let results: [Result]
    let page: Int
    let totalResults: Int
    let dates: Dates
    let totalPages: Int
}

struct Dates: Codable {
    let maximum: String
    let minimum: String
}

struct Result: Codable {
    let voteCount: Int
    let id: Int
    let video: Bool
    let voteAverage: Double
    let title: String
    let popularity: Double
    let posterPath: String
    let originalLanguage: String
    let originalTitle: String
    let genreIDS: [Int]
    let backdropPath: String
    let adult: Bool
    let overview: String
    let releaseDate: String
}



