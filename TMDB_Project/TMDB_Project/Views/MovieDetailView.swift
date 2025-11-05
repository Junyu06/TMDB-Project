//
//  MovieDetailView.swift
//  TMDB_Project
//
//  Created by Junyu Li on 11/5/25.
//

import SwiftUI

struct MovieDetailView: View {
    let movieId: Int
    @StateObject private var viewMode = MovieDetailModel()
    @EnvironmentObject var listModel: MovieListModel
    
    var body: some View {
        ScrollView {
            if let detail = viewMode.movieDetail {
                VStack(alignment: .leading, spacing: 4) {
                    ZStack(alignment: .topTrailing){
                        AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w780\(detail.backdropPath ?? "")")) { img in
                                img.resizable().scaledToFill()
                        } placeholder: {
                            Color.gray.opacity(0.2)
                                .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 300)
                                .clipped()
                        }
                        .frame(maxWidth: .infinity, minHeight: 200, maxHeight: 300)
                        .clipped()
                        .ignoresSafeArea(edges: .top)
                        .cornerRadius(5)
                        
                        Button(action: {
                            listModel.toggleFavorite(detail.id)
                        }) {
                            Image(systemName: listModel.favorites.contains(detail.id) ? "heart.fill" : "heart")
                                .foregroundStyle(listModel.favorites.contains(detail.id) ? .red: .white)
                                .padding(8)
                                .background(Color.black.opacity(0.3))
                                .clipShape(Circle())
                                .padding(4)
                        }
                    }
                    
                    Text(detail.title)
                        .font(.largeTitle)
                        .bold()
                    
                    Text("Overview")
                        .font(.subheadline)
                    
                    Text(detail.overview)
                        .font(.body)
                        .lineLimit(nil)

                    if detail.adult {
                        Text("Adult content")
                            .foregroundColor(.red)
                            .font(.subheadline)
                    } else {
                        Text("Family friendly content")
                            .foregroundColor(.green)
                            .font(.subheadline)
                            .padding(.top, 10)
                    }
                    
                    if !detail.genres.isEmpty {
                        Text("Genres:")
                            .font(.headline)
                            .padding(.top, 4)
                        ForEach(detail.genres) { genre in
                            Text("- \(genre.name)")
                                .font(.subheadline)
                        }
                    }

                    if let runtime = detail.runtime {
                        Text("Runtime: \(runtime) min")
                            .font(.headline)
                            .padding(.top, 10)
                    }

                    if !detail.productionCompanies.isEmpty {
                        Text("Production Companies:")
                            .font(.headline)
                            .padding(.top, 4)
                        ForEach(detail.productionCompanies) { company in
                            Text("- \(company.name)")
                                .font(.subheadline)
                        }
                    }
                    
                }
                
            }
//            Text(String(describing: viewMode.movieDetail))
//                .font(.caption)
        }
        .padding(.horizontal)
        .task {
            await viewMode.fetchMoviesDetail(id: movieId, forceRefresh: false)
        }
        .refreshable {
            await viewMode.fetchMoviesDetail(id: movieId, forceRefresh: true)
        }
        .navigationTitle(Text("Movie Detail"))
    }
}

#Preview {
    MovieDetailView(movieId: 1197137)
        .environmentObject(MovieListModel())
}
