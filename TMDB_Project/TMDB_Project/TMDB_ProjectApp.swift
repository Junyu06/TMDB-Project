//
//  TMDB_ProjectApp.swift
//  TMDB_Project
//
//  Created by Junyu Li on 11/4/25.
//

import SwiftUI
import SwiftData

@main
struct TMDB_ProjectApp: App {
    @StateObject private var listModel = MovieListModel()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(listModel)// make it share for all code
        }
        .modelContainer(sharedModelContainer)
    }
}
