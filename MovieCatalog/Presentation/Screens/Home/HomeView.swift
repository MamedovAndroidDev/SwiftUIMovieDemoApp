//
//  HomeView.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 13.09.26.
//

import SwiftUI
struct HomeView :View {
    
    @State private var viewModel: HomeViewModel
    @Binding var selectedTab: Int

    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    init(viewModel: HomeViewModel, selectedTab: Binding<Int>) {
        _viewModel = State(initialValue: viewModel)
        _selectedTab = selectedTab
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                
                FeaturedBannerView(state: viewModel.popularState) {
                    viewModel.reload(.popular)
                }
                CarouselSectionView(
                    title: MovieCategory.popular.rawValue,
                    category: .popular,
                    state: viewModel.popularState,
                    onRetry: { viewModel.reload(.popular) }
                )

                CarouselSectionView(
                    title: MovieCategory.topRated.rawValue,
                    category: .topRated,
                    state: viewModel.topRatedState,
                    onRetry: { viewModel.reload(.topRated) }
                )

                CarouselSectionView(
                    title: MovieCategory.upcoming.rawValue,
                    category: .upcoming,
                    state: viewModel.upcomingState,
                    onRetry: { viewModel.reload(.upcoming) }
                )

                CarouselSectionView(
                    title: MovieCategory.nowPlaying.rawValue,
                    category: .nowPlaying,
                    state: viewModel.nowPlayingState,
                    onRetry: { viewModel.reload(.nowPlaying) }
                )
            }
            .padding(.vertical)
        }
        .background(AppTheme.background)
        .navigationTitle("Home")
        .task {
            if case .idle = viewModel.popularState {
                viewModel.loadAll()
            }
        }
        .refreshable {
            await viewModel.refresh()
        }
        .onDisappear {
            viewModel.cancelLoading()
        }
        .navigationDestination(for: Movie.self) { movie in
            MovieDetailView(movie: movie)
        }
        .navigationDestination(for: MovieCategory.self) { category in
            SeeAllView(category: category)
        }
    }

  
}




#Preview("Success") {
    NavigationStack {
        HomeView(
            viewModel: HomeViewModel(useCase: PreviewFetchMoviesUseCase(result: .success(MovieResult.mockResult))),
            selectedTab: .constant(0)
        )
    }
}

#Preview("Error") {
    NavigationStack {
        HomeView(
            viewModel: HomeViewModel(useCase: PreviewFetchMoviesUseCase(result: .failure(NetworkError.noInternetConnection))),
            selectedTab: .constant(0)
           
        )
    }
}

#Preview("EmptyDark") {
    NavigationStack {
        HomeView(
            viewModel: HomeViewModel(useCase: PreviewFetchMoviesUseCase(result: .success(MovieResult.emptyResult))),
            selectedTab: .constant(0)
        )
    }
    .preferredColorScheme(.dark)
}
