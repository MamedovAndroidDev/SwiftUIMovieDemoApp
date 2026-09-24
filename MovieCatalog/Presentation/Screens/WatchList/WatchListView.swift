//
//  WatchListView.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 13.09.26.
//
import SwiftUI
struct WatchListView: View {
    @State private var viewModel: WatchListViewModel

    init(viewModel: WatchListViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        content
            .background(AppTheme.background)
            .navigationTitle("Watch list")
            .task { viewModel.loadWatchlist() }
            .navigationDestination(for: Movie.self) { movie in
                MovieDetailView(movie: movie)
            }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .loaded(let movies):
            List(movies) { movie in
                NavigationLink(value: movie) {
                    HStack(spacing: 12) {
                        AsyncImage(url: movie.posterUrl) { phase in
                            switch phase {
                            case .success(let image):
                                image.resizable()
                            default:
                                AppTheme.secondaryBackground
                            }
                        }
                        .frame(width: 60, height: 90)
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                        VStack(alignment: .leading, spacing: 4) {
                            Text(movie.title)
                                .font(.headline)
                                .foregroundStyle(AppTheme.primaryText)

                            RatingBadge(rating: movie.rating)

                            Label(movie.genreNames(from: viewModel.genres), systemImage: "theatermasks")
                                .font(.caption2)
                                .foregroundStyle(AppTheme.secondaryText)

                            Label(movie.releaseYear, systemImage: "calendar")
                                .font(.caption2)
                                .foregroundStyle(AppTheme.secondaryText)
                        }
                    }
                }
                .listRowBackground(AppTheme.background)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)

        case .empty:
            ContentUnavailableView(
                "Watch list boşdur",
                systemImage: "bookmark",
                description: Text("Filmləri bookmark etsən burda görünəcək")
            )

        case .error(let msg):
            ContentUnavailableView(
                "Xəta",
                systemImage: "exclamationmark.triangle",
                description: Text(msg)
            )
        }
    }
}

#Preview("Success") {
    NavigationStack {
        WatchListView(viewModel: WatchListViewModel(
            useCase: PreviewWatchlistUseCase(preloaded: Movie.mockList),
            fetchGenresUseCase: PreviewFetchGenresUseCase()
        ))
    }
}

#Preview("Empty") {
    NavigationStack {
        WatchListView(viewModel: WatchListViewModel(
            useCase: PreviewWatchlistUseCase(),
            fetchGenresUseCase: PreviewFetchGenresUseCase()
        ))
    }
}
