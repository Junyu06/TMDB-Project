//
//  MovieListView.swift
//  TMDB_Project
//
//  Created by Junyu Li on 11/5/25.
//

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
                        await listModel.fetchMovies(timeWindow: newValue)
                    }
                }
                LazyVGrid(columns: columns, spacing: 40) {
                    ForEach(listModel.movies) { movie in
                        MovieCardView(
                            movie: movie,
                            isFavorite: listModel.favorites.contains(movie.id)
                        ){
                            listModel.toggleFavorite(movie.id)
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

//#Preview {
//    MovieListView()
//}
