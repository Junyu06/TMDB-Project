//
//  MovieListView.swift
//  TMDB_Project
//
//  Created by Junyu Li on 11/5/25.
//
// This code handles the UI for wrap the MovieCardView into a list view

import SwiftUI

struct MovieListView: View {
    //@StateObject private var viewModel = MovieListModel()
    @EnvironmentObject var listModel: MovieListModel
    @State private var selectedTimeWindow = "day"
    
    private let columns = [
        GridItem(.flexible()), GridItem(.flexible())
    ]
        
    var body: some View {
        VStack{
            if let errorMessage = listModel.errorMessage {
                // Error state
                VStack(spacing: 16) {
                    Image(systemName: "wifi.slash")
                        .font(.system(size: 60))
                        .foregroundColor(.secondary)

                    Text("Internet Issues")
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text(errorMessage)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    Button(action: {
                        Task {
                            await listModel.fetchMovies(timeWindow: selectedTimeWindow, forceRefresh: true)
                        }
                    }) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                            Text("Retry")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .cornerRadius(10)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if listModel.isLoading && listModel.movies.isEmpty {
                // Loading state (only when no movies are loaded yet)
                VStack(spacing: 16) {
                    ProgressView()
                        .scaleEffect(1.5)
                    Text("Loading movies...")
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                // Content state
                ScrollView{
                    Picker("Time Window", selection: $selectedTimeWindow){
                        Text("Today").tag("day")
                        Text("This Week").tag("week")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding([.horizontal, .top])
                    .onChange(of: selectedTimeWindow) { oldValue, newValue in
                        Task {
                            await listModel.fetchMovies(timeWindow: newValue)
                        }
                    }

                    if listModel.isLoading {
                        // Show loading indicator while refreshing
                        ProgressView()
                            .padding()
                    }

                    LazyVGrid(columns: columns, spacing: 40) {
                        ForEach(listModel.movies) { movie in
                            MovieCardView(
                                movie: movie,
                                isFavorite: listModel.isFavorite(movie.id)
                            ){
                                listModel.toggleFavorite(movie.id, title: movie.title, posterPath: movie.posterPath)
                            }
                        }
                    }
                    .padding()
                }
                .navigationTitle("Trending Movies")
                .task {
                    await listModel.fetchMovies(timeWindow: selectedTimeWindow, forceRefresh: false)
                }
                .refreshable {
                    await listModel.fetchMovies(timeWindow: selectedTimeWindow, forceRefresh: true)
                }
            }
        }
    }
}

//#Preview {
//    MovieListView()
//}
