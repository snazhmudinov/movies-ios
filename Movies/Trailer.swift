//
//  Trailer.swift
//  Movies
//
//  Created by Sheroz Nazhmudinov on 2/25/18.
//  Copyright © 2018 Sheroz Nazhmudinov. All rights reserved.
//

import Foundation
import ObjectMapper

class Trailer: Mappable {
    var id: Int?
    var results: [Result]?
    
    required init?(map: Map) { }
    
    func mapping(map: Map) {
        id <- map["id"]
        results <- map["results"]
    }
}

class Result: Mappable {
    var id: String?
    var iso_639_1: String?
    var iso_3166_1: String?
    var key: String?
    var name: String?
    var site: String?
    var size: Int?
    var type: String?
    
    required init?(map: Map) { }

    func mapping(map: Map) {
        id <- map["id"]
        iso_639_1 <- map["iso_639_1"]
        iso_3166_1 <- map["iso_3166_1"]
        key <- map["key"]
        name <- map["name"]
        site <- map["site"]
        size <- map["size"]
        type <- map["type"]
    }
}
