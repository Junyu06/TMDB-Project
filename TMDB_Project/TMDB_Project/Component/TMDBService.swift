//
//  TMDBService.swift
//  TMDB_Project
//
//  Created by Junyu Li on 11/4/25.
//

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
    let genres: [Genre]
    let releaseDate: String?
    let adult: Bool
    let runtime: Int?
    let productionCompanies: [ProductionCompany]
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, genres, adult, runtime
        case backdropPath = "backdrop_path"
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

//use actor to prevent locking issues
class TMDBService {
    private let apiKey = Bundle.main.object(forInfoDictionaryKey: "TMDB_API_KEY") as? String ?? ""
    private let baseURL = Bundle.main.object(forInfoDictionaryKey: "TMDB_BASE_URL") as? String ?? ""
    
    //cache for the movie detail
    static let shared = TMDBService()
    private var detailCache: [Int: MovieDetail] = [:]
    private var trendingCache: [String: [Movie]] = [:]
    
    //get the trending movies from the TMDB
    //return a movie structure
    func fetchTrendingMovies(timeWindow: String = "day", forceRefresh: Bool = false) async throws -> [Movie]{
        //if cached
        if !forceRefresh, let cached = trendingCache[timeWindow] {
            print("[TMDService] Using cached trending list for \(timeWindow)")
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
    
    func fetchMovieDetail(id: Int, forceRefresh: Bool = false) async throws -> MovieDetail {
        //if cached
        if !forceRefresh, let cached = detailCache[id] {
            print("[TMDService] Using cached for id: ", id)
            return cached
        }
        
        //not yet cached
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
        
        //testing
//        if let jsonString = String(data: data, encoding: .utf8) {
//            print("[DEBUG] Raw JSON response for movie id \(id):")
//            print(jsonString)
//        }
        let detail = try JSONDecoder().decode(MovieDetail.self, from: data)
        
        //cached and return
        detailCache[id] = detail
        return detail
    }
}
