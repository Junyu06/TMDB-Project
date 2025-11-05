//
//  MovieCardView.swift
//  TMDB_Project
//
//  Created by Junyu Li on 11/5/25.
//

import SwiftUI

struct MovieCardView: View {
    let movie: Movie
    let isFavorite: Bool
    let onFavoriteToggle: () -> Void
    
    var body: some View {
        NavigationLink(destination: MovieDetailView(movieId: movie.id)) {
            VStack(alignment: .leading, spacing: 4) {
                ZStack(alignment: .topTrailing) {
                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "")")!) { img in
                        img.resizable().scaledToFill()
                    } placeholder: {
                        Color.gray.opacity(0.2)
                    }
                    .frame(width: 150, height: 210)
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                    .clipped()

                    Button(action: onFavoriteToggle) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundStyle(isFavorite ? .red : .white)
                            .padding(6)
                            .background(Color.black.opacity(0.3))
                            .clipShape(Circle())
                            .padding(4)
                    }
                }
                VStack(alignment: .leading, spacing: 0) {
                    Text(movie.title)
                        .font(.headline)
                        .foregroundColor(.black)
                        .lineLimit(1)
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("\(movie.voteAverage ?? 0, specifier: "%.1f")")
                            .foregroundColor(.black)
                    }
                }
            }
            .padding(.top, 0)
            .frame(width: 160, height: 240)
        }
        .buttonStyle(PlainButtonStyle())
        .contentShape(Rectangle())
    }
}

#Preview {
    MovieCardView(
        movie: Movie(
                    id: 1,
                    title: "Inception",
                    overview: "might nill",
                    posterPath: "",
                    releaseDate: "2010-07-16",
                    voteAverage: 8.8
                ),
                isFavorite: true,
                onFavoriteToggle: {}
    )
}
