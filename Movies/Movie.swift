import Foundation
import ObjectMapper

class Movie: Mappable {
    var page: Int?
    var totalResults: Int?
    var totalPages: Int?
    var results: [Result]?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        page <- map["page"]
        totalResults <- map["total_results"]
        totalPages <- map["total_pages"]
        results <- map["results"]
    }
    
class Result: Mappable {
    var voteCount: Int?
    var id: Int?
    var video: Bool?
    var voteAverage: Double?
    var title: String?
    var popularity: Double?
    var posterPath: String?
    var originalLanguage: String?
    var originalTitle: String?
    var genreIDS: [Int]?
    var backdropPath: String?
    var adult: Bool?
    var overview: String?
    var releaseDate: String?

    required init?(map: Map) { }

    func mapping(map: Map) {
        voteCount <- map["vote_count"]
        id <- map["id"]
        video <- map["video"]
        voteAverage <- map["vote_average"]
        title <- map["title"]
        popularity <- map["popularity"]
        posterPath <- map["poster_path"]
        originalLanguage <- map["original_language"]
        originalTitle <- map["original_title"]
        genreIDS <- map["genre_ids"]
        backdropPath <- map["backdrop_path"]
        adult <- map["adult"]
        overview <- map["overview"]
        releaseDate <- map["release_date"]
    }
    
}

}
