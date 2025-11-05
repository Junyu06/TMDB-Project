//
//  MovieListModel.swift
//  TMDB_Project
//
//  Created by Junyu Li on 11/5/25.
//
// Handles the logic of fetch movie list
// Handles the favorite system logic

import SwiftUI
import Combine

@MainActor
class MovieListModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var favorites: [FavoriteMovie] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private let service = TMDBService.shared

    //get trending movie
    func fetchMovies(timeWindow: String = "day", forceRefresh: Bool = false) async {
        isLoading = true
        errorMessage = nil

        do {
            let fetched = try await service.fetchTrendingMovies(timeWindow: timeWindow, forceRefresh: forceRefresh)
            self.movies = fetched
            isLoading = false
        } catch {
            print("Error fetching movies: \(error)")
            errorMessage = "Failed to load movies. Please check your internet connection."
            isLoading = false
        }
    }

    //function to toggle favorite on movie
    func toggleFavorite(_ id: Int, title: String, posterPath: String?){
        let favorite = FavoriteMovie(id: id, title: title, posterPath: posterPath)
        print("[MovieListModel] Toggling favorite - id: \(id), title: \(title), posterPath: \(posterPath ?? "nil")")
        if let index = favorites.firstIndex(where: { $0.id == id }) {
            favorites.remove(at: index)
            print("[MovieListModel] Removed from favorites")
        } else {
            favorites.append(favorite)
            print("[MovieListModel] Added to favorites")
        }
        saveFavorites()
    }

    //check if a movie is favorited
    func isFavorite(_ id: Int) -> Bool {
        return favorites.contains(where: { $0.id == id })
    }

    //clear all favorites
    func clearFavorites() {
        favorites.removeAll()
        UserDefaults.standard.removeObject(forKey: "favorites")
        print("[MovieListModel] All favorites cleared")
    }

    //save favorites to UserDefaults
    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: "favorites")
        }
    }

    //set initialize to recover the previous saved favorites
    init() {
        if let saved = UserDefaults.standard.data(forKey: "favorites"),
           let decoded = try? JSONDecoder().decode([FavoriteMovie].self, from: saved) {
            favorites = decoded
        }
    }
}
