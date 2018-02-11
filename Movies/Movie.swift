// To parse the JSON, add this file to your project and do:
//
//   let movie = try? JSONDecoder().decode(Movie.self, from: jsonData)

import Foundation

struct Movie: Codable {
    let results: [Result]
    let page: Int
    let totalResults: Int
    let dates: Dates
    let totalPages: Int
    
    enum CodingKeys: String, CodingKey {
        case results = "results"
        case page = "page"
        case totalResults = "total_results"
        case dates = "dates"
        case totalPages = "total_pages"
    }
}

struct Dates: Codable {
    let maximum: String
    let minimum: String
    
    enum CodingKeys: String, CodingKey {
        case maximum = "maximum"
        case minimum = "minimum"
    }
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
    
    enum CodingKeys: String, CodingKey {
        case voteCount = "vote_count"
        case id = "id"
        case video = "video"
        case voteAverage = "vote_average"
        case title = "title"
        case popularity = "popularity"
        case posterPath = "poster_path"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case genreIDS = "genre_ids"
        case backdropPath = "backdrop_path"
        case adult = "adult"
        case overview = "overview"
        case releaseDate = "release_date"
    }
}
