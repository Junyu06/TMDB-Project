//
//  SettingsView.swift
//  TMDB_Project
//
//  Created by Junyu Li on 11/4/25.
//
// This code handles the UI & Logic of reset cache and the favorites

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var listModel: MovieListModel
    @State private var showingClearCacheAlert = false
    @State private var showingClearFavoritesAlert = false

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Cache Management")) {
                    Button(action: {
                        showingClearCacheAlert = true
                    }) {
                        HStack {
                            Image(systemName: "arrow.clockwise.circle")
                            Text("Clear API Cache")
                        }
                    }
                    .foregroundColor(.blue)
                }

                Section(header: Text("Data Management")) {
                    HStack {
                        Text("Favorites Count")
                        Spacer()
                        Text("\(listModel.favorites.count)")
                            .foregroundColor(.secondary)
                    }

                    Button(action: {
                        if listModel.favorites.count > 0 {
                            showingClearFavoritesAlert = true
                        }
                    }) {
                        HStack {
                            Image(systemName: "trash")
                            Text("Clear All Favorites")
                        }
                    }
                    .foregroundColor(.red)
                    .disabled(listModel.favorites.count == 0)
                }

                Section(header: Text("About")) {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .alert("Clear API Cache?", isPresented: $showingClearCacheAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Clear", role: .destructive) {
                    TMDBService.shared.clearCache()
                }
            } message: {
                Text("This will clear all cached movie data. You may need to reload content.")
            }
            .alert("Clear All Favorites?", isPresented: $showingClearFavoritesAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Clear", role: .destructive) {
                    listModel.clearFavorites()
                }
            } message: {
                Text("This will permanently delete all \(listModel.favorites.count) favorite(s). This action cannot be undone.")
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(MovieListModel())
}
