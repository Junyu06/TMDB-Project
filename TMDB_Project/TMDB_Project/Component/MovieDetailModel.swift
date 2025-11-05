//
//  MovieDetailModel.swift
//  TMDB_Project
//
//  Created by Junyu Li on 11/5/25.
//
// This file handles the logic of MovieDetailView.swift

import Foundation
import Combine

@MainActor
class MovieDetailModel: ObservableObject {
    @Published var movieDetail: MovieDetail? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private let service = TMDBService.shared

    //get the movie detail
    func fetchMoviesDetail(id: Int = 1197137, forceRefresh: Bool = false) async {
        isLoading = true
        errorMessage = nil

        do {
            let fetched = try await service.fetchMovieDetail(id: id, forceRefresh: forceRefresh)
            self.movieDetail = fetched
            isLoading = false
        } catch {
            print("Error fetching movies: \(error)")
            errorMessage = "Failed to load movie details. Please check your internet connection."
            isLoading = false
        }
    }
}
