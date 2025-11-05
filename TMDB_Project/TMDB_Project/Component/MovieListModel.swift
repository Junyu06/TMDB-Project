//
//  MovieListModel.swift
//  TMDB_Project
//
//  Created by Junyu Li on 11/5/25.
//

import SwiftUI
import Combine

@MainActor
class MovieListModel: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var favorites: Set<Int> = []
    
    private let service = TMDBService()
    
    //get trending movie
    func fetchMovies(timeWindow: String = "day", forceRefresh: Bool = false) async {
        do {
            let fetched = try await service.fetchTrendingMovies(timeWindow: timeWindow, forceRefresh: forceRefresh)
            self.movies = fetched
        } catch {
            print("Error fetching movies: \(error)")
        }
    }
    
    //function to toggle favorite on movie
    func toggleFavorite(_ id: Int){
        if favorites.contains(id) {
            favorites.remove(id)
        } else {
            favorites.insert(id)
        }
        UserDefaults.standard.set(Array(favorites), forKey: "favorites")
    }
    
    //set initialize to recover the previous saved favorites
    init() {
        if let saved = UserDefaults.standard.array(forKey: "favorites") as? [Int] {
            favorites = Set(saved)
        }
    }
}
