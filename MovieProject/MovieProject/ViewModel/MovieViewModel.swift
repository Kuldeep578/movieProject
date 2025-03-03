//
//  MovieViewModel.swift
//  MovieProject
//
//  Created by kuldeep Singh on 03/03/25.
//

import Foundation
import Combine
// MARK: - ViewModel
@MainActor
class MovieViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var favorites: Set<Int> = []
    @Published var searchText: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let persistenceController = PersistenceController.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadFavorites()
        fetchMovies()
        setupSearch()
    }
    
    func fetchMovies() {
        Task {
            isLoading = true
            errorMessage = nil
            do {
                movies = try await MovieService.shared.fetchMovies()
                persistenceController.saveMovies(movies)
            } catch {
                movies = persistenceController.fetchSavedMovies()
               errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }
    

    func searchMovies() {
        guard !searchText.isEmpty else {
            fetchMovies()
            return
        }
        
        Task { @MainActor in  // Ensure execution on main thread
            isLoading = true
            errorMessage = nil
            do {
                let searchResults = try await MovieService.shared.searchMovies(query: searchText)
                let firstCharacter = searchText.prefix(1).lowercased()
                movies = searchResults.sorted {
                    let title1 = $0.title.lowercased()
                    let title2 = $1.title.lowercased()
                    let startsWithFirstChar1 = title1.hasPrefix(firstCharacter)
                    let startsWithFirstChar2 = title2.hasPrefix(firstCharacter)

                    if startsWithFirstChar1 != startsWithFirstChar2 {
                        return startsWithFirstChar1
                    }
                    return title1 < title2
                }
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    
    private func setupSearch() {
            $searchText
                .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
                .removeDuplicates()
                .sink { [weak self] newText in
                    self?.searchMovies()
                }
                .store(in: &cancellables)
        }
    
    func toggleFavorite(movie: Movie) {
        if favorites.contains(movie.id) {
            favorites.remove(movie.id)
        } else {
            favorites.insert(movie.id)
        }
        persistenceController.saveFavorites(favorites)
    }
    
    private func loadFavorites() {
        favorites = persistenceController.loadFavorites()
    }
}
