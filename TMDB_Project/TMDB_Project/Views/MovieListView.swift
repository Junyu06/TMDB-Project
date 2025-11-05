//
//  MovieListView.swift
//  TMDB_Project
//
//  Created by Junyu Li on 11/5/25.
//

import SwiftUI

struct MovieListView: View {
    @StateObject private var viewModel = MovieListModel()
    @State private var selectedTimeWindow = "day"
    
    private let columns = [
        GridItem(.flexible()), GridItem(.flexible())
    ]
        
    var body: some View {
        VStack{
            ScrollView{
                Picker("Time Window", selection: $selectedTimeWindow){
                    Text("Today").tag("day")
                    Text("This Week").tag("week")
                }
                //.pickerStyle(.segmented)
                .pickerStyle(SegmentedPickerStyle())
                .padding([.horizontal, .top])
                .onChange(of: selectedTimeWindow) { oldValue, newValue in
                    Task {
                        await viewModel.fetchMovies(timeWindow: newValue)
                    }
                }
                LazyVGrid(columns: columns, spacing: 40) {
                    ForEach(viewModel.movies) { movie in
                        MovieCardView(
                            movie: movie,
                            isFavorite: viewModel.favorites.contains(movie.id)
                        ){
                            viewModel.toggleFavorite(movie.id)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Trending Movies")
            .task {
                await viewModel.fetchMovies(timeWindow: selectedTimeWindow)
            }
        }
    }
}

//#Preview {
//    MovieListView()
//}
