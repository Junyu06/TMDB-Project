//
//  HomeView.swift
//  TMDB_Project
//
//  Created by Junyu Li on 11/4/25.
//
// This file handles the UI of Home View which warped the MovieListVide

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            VStack {
                //Text("TMDBService Test")
                MovieListView()
            }
            .navigationTitle("TMDB Movie")
            .navigationBarTitleDisplayMode(.automatic)
        }
    }
}

#Preview {
    HomeView()
}
