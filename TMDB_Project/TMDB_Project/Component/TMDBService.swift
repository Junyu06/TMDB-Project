//
//  TMDBService.swift
//  TMDB_Project
//
//  Created by Junyu Li on 11/4/25.
//

import Foundation

struct MovieResponse: Codable {
    let results: [Movie]
}

struct Movie: Identifiable, Codable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String?
    let voteAverage: Double?

    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}

class TMDBService {
    private let apiKey = Bundle.main.object(forInfoDictionaryKey: "TMDB_API_KEY") as? String ?? ""
    private let baseURL = Bundle.main.object(forInfoDictionaryKey: "TMDB_BASE_URL") as? String ?? ""
    
    //get the trending movies from the TMDB
    //return a movie structure
    func fetchTrendingMovies(timeWindow: String = "day") async throws -> [Movie]{
        guard let url = URL(string: "\(baseURL)/trending/movie/\(timeWindow)") else {
            throw URLError(.badURL)
        }
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "en-US")
        ]
        components.queryItems = queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(apiKey)"
        ]

        let (data, _) = try await URLSession.shared.data(for: request)
        let movies = try decodeMovies(from: data)
        for movie in movies {
            print(movie.id)
            print(movie.title)
            print(movie.posterPath ?? "No poster")
        }
        return movies
    }
    
    //handling convert json to movie structure
    func decodeMovies(from data: Data) throws -> [Movie] {
        let decoder = JSONDecoder()
        let response = try decoder.decode(MovieResponse.self, from: data)
        return response.results
    }
}
