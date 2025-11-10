# TMDB Movie App

A simple, clean SwiftUI app built for the Mobile App Developer assessment.
A SwiftUI-based iOS application that fetches and displays trending movies from The Movie Database (TMDB) API, allowing users to browse movies, view detailed information, and manage their favorites.

Github Page: `https://github.com/Junyu06/TMDB-Project`

Presentation & Demo `https://youtu.be/s94Cd61AkVI`

## Features

- **Browse Trending Movies**: View daily or weekly trending movies from TMDB
- **Movie Details**: Access comprehensive information about each movie including:
  - Title, overview, and poster
  - Release date and runtime
  - Genres and production companies
  - User ratings
- **Favorites Management**: Save and manage your favorite movies locally
- **Caching System**: Efficient data caching for improved performance and reduced API calls
- **Tab-Based Navigation**: Easy navigation between Home, Favorites, and Settings

## Project Structure

```
TMDB_Project/
├── Component/
│   ├── TMDBService.swift       # API service layer
│   ├── MovieListModel.swift    # View model for movie list
│   └── MovieDetailModel.swift  # View model for movie details
├── Views/
│   ├── MovieListView.swift     # Movie list display
│   ├── MovieCardView.swift     # Movie card component
│   └── MovieDetailView.swift   # Movie detail screen
├── Tabs/
│   ├── HomeView.swift          # Home tab wrapper
│   ├── FavoritesView.swift     # Favorites tab
│   └── SettingsView.swift      # Settings tab
├── ContentView.swift            # Main tab view
└── TMDB_ProjectApp.swift       # App entry point
Configs/
└── TMDBConfig.xcconfig       # API & URL Storage
```

## Setup

### Prerequisites

- Xcode 15.0 or later
- iOS 17.0+ deployment target
- TMDB API key (get one at [TMDB](https://www.themoviedb.org/settings/api))

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/TMDB-Project.git
cd TMDB-Project
```

2. Configure TMDB API credentials:
    - Open the project in Xcode
    - Create a folder named Configs in the TMDB_Project folder
    - Create a TMDBConfig.xcconfig in the Configs folder
    - Add your TMDB API key to TMDBConfig.xcconfig:
        - Key: `TMDB_API_KEY`
        - Value: Your TMDB Bearer Token
    - Add TMDB base URL to TMDBConfig.xcconfig:
        - Key: `TMDB_BASE_URL`
        - Value: `https:/$()/api.themoviedb.org/3`
        *(Note: the `$()` is intentional — avoids `//` comment issues in .xcconfig)*

3. Go to the TMDB_Project properties in Xcode
    - At the info section, under configuration, make sure select both Debug and Release use the TMDBConfig.xcconfig

4. Build and run the project in Xcode

## Key Features Implementation

### API Service

This app uses the following TMDB API endpoints:
- `GET /trending/movie/{time_window}` - Fetch trending movies
- `GET /movie/{movie_id}` - Fetch movie details

### Caching

Trending movie lists and movie details are cached locally to minimize network usage and improve performance across sessions.

Caching uses in-memory storage combined with simple persistence for faster reloads.

### UI Components

Reusable SwiftUI components such as MovieCardView and MovieDetailView.

## Usage

1. **Browse Movies**: Launch the app to see trending movies on the Home tab
2. **View Details**: Tap any movie card to see full details
3. **Add to Favorites**: Tap the heart icon to save movies to your favorites

## Acknowledgments

- Movie data provided by [The Movie Database (TMDB)](https://www.themoviedb.org/)
- Movie posters and images are property of their respective owners
