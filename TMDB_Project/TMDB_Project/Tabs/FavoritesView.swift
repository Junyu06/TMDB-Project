//
//  FavoritesView.swift
//  TMDB_Project
//
//  Created by Junyu Li on 11/4/25.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var listModel: MovieListModel

    var body: some View {
        NavigationView {
        }
    }
}

#Preview {
    FavoritesView()
        .environmentObject(MovieListModel())
}
