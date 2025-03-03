//
//  Movie.swift
//  MovieProject
//
//  Created by kuldeep Singh on 03/03/25.
//

import SwiftUI
import Combine

// MARK: - Movie Model
struct Movie: Identifiable, Codable {
    let id: Int
    let title: String
    let overview: String
    let releaseDate: String?
    let posterPath: String?
    
    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500" + path)
    }
    
    enum CodingKeys: String, CodingKey {
            case id, title, overview
            case releaseDate = "release_date"
            case posterPath = "poster_path"
        }
}

struct MovieResponse: Codable {
    let results: [Movie]
}




