//
//  FavoritesView.swift
//  TMDB_Project
//
//  Created by Junyu Li on 11/4/25.
//
// This code handles the UI of favorites tab

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var listModel: MovieListModel
    @State private var refreshID = UUID()

    var body: some View {
        NavigationView {
            if listModel.favorites.isEmpty {
                VStack {
                    Text("No favorites yet")
                        .font(.title2)
                        .foregroundColor(.secondary)
                        .padding()
                }
            } else {
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(listModel.favorites) { movie in
                            HStack {
                                NavigationLink(destination: MovieDetailView(movieId: movie.id)) {
                                    HStack {
                                        AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w300\(movie.posterPath ?? "")")) { image in
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 80, height: 80)
                                                .clipped()
                                                .cornerRadius(8)
                                        } placeholder: {
                                            Color.gray.opacity(0.2)
                                                .frame(width: 80, height: 80)
                                                .cornerRadius(8)
                                        }

                                        Text(movie.title)
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                            .lineLimit(2)
                                    }
                                }

                                Spacer()

                                Button {
                                    listModel.toggleFavorite(movie.id, title: movie.title, posterPath: movie.posterPath)
                                } label: {
                                    Image(systemName: listModel.isFavorite(movie.id) ? "heart.fill" : "heart")
                                }
                                .foregroundColor(.red)
                                .font(.title3)
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    .padding()
                }
                .navigationTitle("Favorites")
                .id(refreshID)
            }
        }
        .onAppear {
            print("[FavoritesView] onAppear - favorites count: \(listModel.favorites.count)")
            for (index, fav) in listModel.favorites.enumerated() {
                print("[FavoritesView] Favorite #\(index): id=\(fav.id), title=\(fav.title), posterPath=\(fav.posterPath ?? "nil")")
            }
            refreshID = UUID()
        }
    }
}

#Preview {
    FavoritesView()
        .environmentObject(MovieListModel())
}
