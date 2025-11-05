//
//  HomeView.swift
//  TMDB_Project
//
//  Created by Junyu Li on 11/4/25.
//

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
