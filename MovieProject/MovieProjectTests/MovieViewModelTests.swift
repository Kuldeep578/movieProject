//
//  MovieViewModelTests.swift
//  MovieProjectTests
//
//  Created by kuldeep Singh on 03/03/25.
//

import XCTest
import Combine
@testable import MovieProject

@MainActor
class MovieViewModelTests: XCTestCase {
    var viewModel: MovieViewModel!
    var cancellables: Set<AnyCancellable>!
    
    @MainActor override func setUp() {
        super.setUp()
        viewModel = MovieViewModel()
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchMovies() async {
        let expectation = XCTestExpectation(description: "Fetch movies")
        
       viewModel.$movies
            .dropFirst()
            .sink { movies in
                XCTAssertFalse(movies.isEmpty, "Movies should be fetched successfully")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchMovies()
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    
    func testSearchMovies() async {
        Task { @MainActor in
            viewModel.searchText = "Avengers"
        }
        let expectation = XCTestExpectation(description: "Search movies")
        
        viewModel.$movies
            .dropFirst()
            .sink { movies in
                XCTAssertFalse(movies.isEmpty, "Movies should be filtered based on search text")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.searchMovies()
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    
    @MainActor func testToggleFavorite() {
        let movie = Movie(id: 1, title: "Test Movie", overview: "Overview", releaseDate: "2025-01-01", posterPath: nil)
        
        XCTAssertFalse(viewModel.favorites.contains(movie.id), "Movie should not be in favorites initially")
        
        viewModel.toggleFavorite(movie: movie)
        XCTAssertTrue(viewModel.favorites.contains(movie.id), "Movie should be added to favorites")
        
        viewModel.toggleFavorite(movie: movie)
        XCTAssertFalse(viewModel.favorites.contains(movie.id), "Movie should be removed from favorites")
    }
}
