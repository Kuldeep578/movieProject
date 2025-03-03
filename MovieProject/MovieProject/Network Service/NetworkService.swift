//
//  NetworkService.swift
//  MovieProject
//
//  Created by kuldeep Singh on 03/03/25.
//
import Foundation

// MARK: - API Service
class MovieService {
    static let shared = MovieService()
    private let apiKey = "f6ca9bf664d6d41dc00850084339453e"
    
    func fetchMovies() async throws -> [Movie] {
        let urlString = "https://api.themoviedb.org/3/discover/movie?api_key=\(apiKey)"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
        return decodedResponse.results
    }
    
    func searchMovies(query: String) async throws -> [Movie] {
        let urlString = "https://api.themoviedb.org/3/search/movie?query=\(query)&api_key=\(apiKey)"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let decodedResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
        return decodedResponse.results
    }
}

