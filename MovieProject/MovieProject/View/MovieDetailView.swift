//
//  MovieDetailView.swift
//  MovieProject
//
//  Created by kuldeep Singh on 03/03/25.
//

import SwiftUI

// MARK: - Movie Detail View
struct MovieDetailView: View {
    let movie: Movie
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                AsyncImage(url: movie.posterURL) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 200, height: 300)
                .cornerRadius(12)
                
                Text(movie.title).font(.title).bold()
                Text(movie.overview).padding()
                Text("Release Date: \(movie.releaseDate ?? "N/A")").foregroundColor(.gray)
            }
            .padding()
        }
        .navigationTitle("Movie Details")
    }
}

//#Preview {
  //  MovieDetailView()
//}
