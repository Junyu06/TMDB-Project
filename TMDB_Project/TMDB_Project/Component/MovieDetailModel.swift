//
//  MovieDetailModel.swift
//  TMDB_Project
//
//  Created by Junyu Li on 11/5/25.
//

import Foundation
import Combine

@MainActor
class MovieDetailModel: ObservableObject {
    @Published var movieDetail: MovieDetail? = nil
    
    private let service = TMDBService()
    
    //get the movie detail
    func fetchMoviesDetail(id: Int = 1197137, forceRefresh: Bool = false) async {
        do {
            let fetched = try await service.fetchMovieDetail(id: id, forceRefresh: forceRefresh)
            self.movieDetail = fetched
        } catch {
            print("Error fetching movies: \(error)")
        }
    }
}
