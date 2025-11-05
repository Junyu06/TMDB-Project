//
//  API_Test.swift
//  TMDB_Project
//
//  Created by Junyu Li on 11/4/25.
//
// This is an tester for testing is xcconfig loaded to the environment or not

import SwiftUI

struct API_Test: View {
    var body: some View {
        NavigationStack {
            VStack {
                //todo
            }
        }
        .onAppear {
                    if let key = Bundle.main.object(forInfoDictionaryKey: "TMDB_API_KEY") as? String {
                        print("TMDB API Key Loaded: \(key)")
                    } else {
                        print("Could not find TMDB_API_KEY")
                    }
        }
        .onAppear {
                    if let key = Bundle.main.object(forInfoDictionaryKey: "TMDB_BASE_URL") as? String {
                        print("TMDB BASE URL Loaded: \(key)")
                    } else {
                        print("Could not find TMDB_BASE_URL")
                    }
                }
    }
}

#Preview {
    HomeView()
}
