//
//  MovieListView.swift
//  MovieProject
//
//  Created by kuldeep Singh on 03/03/25.
//
import SwiftUI
import SDWebImageSwiftUI

// MARK: - Movie List View
struct MovieListView: View {
    @StateObject private var viewModel = MovieViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $viewModel.searchText, onSearch: {
                    viewModel.searchMovies()
                })
                List(viewModel.movies) { movie in
                    NavigationLink(destination: MovieDetailView(movie: movie)) {
                        MovieRowView(viewModel: viewModel, movie: movie)
                    }
                }
                .listStyle(PlainListStyle())
                .navigationTitle("Movies")
            }
        }
    }
}

// MARK: - Search Bar
struct SearchBar: View {
    @Binding var text: String
    var onSearch: () -> Void
    
    var body: some View {
        HStack {
            TextField("Search movies...", text: $text, onCommit: onSearch)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button(action: onSearch) {
                Image(systemName: "magnifyingglass")
                    .padding()
            }
        }
    }
}




// MARK: - Movie Row View
struct MovieRowView: View {
    @ObservedObject var viewModel: MovieViewModel
    let movie: Movie
    
    var body: some View {
        HStack {
            WebImage(url: movie.posterURL)
                .resizable()
              //  .placeholder { ProgressView() }
                .frame(width: 50, height: 75)
                .cornerRadius(8)
                
            VStack(alignment: .leading) {
                Text(movie.title).font(.headline)
                Text(movie.releaseDate ?? "Unknown").font(.subheadline).foregroundColor(.gray)
            }
            Spacer()
            Button(action: { viewModel.toggleFavorite(movie: movie) }) {
                Image(systemName: viewModel.favorites.contains(movie.id) ? "heart.fill" : "heart")
                    .foregroundColor(.red)
            }
            .buttonStyle(PlainButtonStyle()) 
        }
    }
}
