//
//  TMDBService.swift
//  TMDB_Project
//
//  Created by Junyu Li on 11/4/25.
//
// This code handles the API connecton

import Foundation

struct MovieResponse: Codable, Sendable {
    let results: [Movie]
}

struct Movie: Identifiable, Codable, Sendable {
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

struct MovieDetail: Codable, Sendable {
    let id: Int
    let title: String
    let overview: String
    let backdropPath: String?
    let posterPath: String?
    let genres: [Genre]
    let releaseDate: String?
    let adult: Bool
    let runtime: Int?
    let productionCompanies: [ProductionCompany]

    enum CodingKeys: String, CodingKey {
        case id, title, overview, genres, adult, runtime
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case productionCompanies = "production_companies"
    }
}

struct ProductionCompany: Codable, Identifiable, Sendable {
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
    }
}

struct Genre: Codable, Identifiable, Sendable {
    let id: Int
    let name: String
}

struct FavoriteMovie: Codable, Identifiable, Sendable, Hashable {
    let id: Int
    let title: String
    let posterPath: String?

    enum CodingKeys: String, CodingKey {
        case id, title
        case posterPath = "poster_path"
    }
}

//use actor to prevent locking issues
class TMDBService {
    private let apiKey = Bundle.main.object(forInfoDictionaryKey: "TMDB_API_KEY") as? String ?? ""
    private let baseURL = Bundle.main.object(forInfoDictionaryKey: "TMDB_BASE_URL") as? String ?? ""
    
    //cache for the movie detail
    static let shared = TMDBService()
    private var detailCache: [Int: MovieDetail] = [:]
    private var trendingCache: [String: [Movie]] = [:]

    //clear all caches
    func clearCache() {
        detailCache.removeAll()
        trendingCache.removeAll()
        print("[TMDBService] All caches cleared")
    }

    //get the trending movies from the TMDB
    //return a movie structure
    func fetchTrendingMovies(timeWindow: String = "day", forceRefresh: Bool = false) async throws -> [Movie]{
        //if cached
        if !forceRefresh, let cached = trendingCache[timeWindow] {
            print("[TMDBService] Using cached trending list for \(timeWindow)")
            return cached
        }
        
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
//        for movie in movies {
//            print(movie.id)
//            print(movie.title)
//            print(movie.posterPath ?? "No poster")
//        }
        
        trendingCache[timeWindow] = movies
        return movies
    }
    
    //handling convert json to movie structure
    func decodeMovies(from data: Data) throws -> [Movie] {
        let decoder = JSONDecoder()
        let response = try decoder.decode(MovieResponse.self, from: data)
        return response.results
    }
    
    //fech the movie detail from TMDB for single movie
    func fetchMovieDetail(id: Int, forceRefresh: Bool = false) async throws -> MovieDetail {
        //if cached
        if !forceRefresh, let cached = detailCache[id] {
            print("[TMDBService] Using cached movie detail for id: \(id)")
            return cached
        }

        //not yet cached
        //print("[TMDBService] Fetching movie detail from API for id: \(id)")
        guard let url = URL(string: "\(baseURL)/movie/\(id)") else {
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

        let detail = try JSONDecoder().decode(MovieDetail.self, from: data)
        print("[TMDBService] Movie detail decoded - id: \(detail.id), posterPath: \(detail.posterPath ?? "nil")")

        //cached and return
        detailCache[id] = detail
        return detail
    }
}
