//
//  SeeAllView.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 21.09.26.
//

import SwiftUI
import SwiftUI

struct SeeAllView: View {

    @State private var viewModel: SeeAllViewModel

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    init(category: MovieCategory) {
        _viewModel = State(
            initialValue: SeeAllViewModel(
                category: category,
                useCase: DIContainer.shared.fetchMovieUseCase
            )
        )
    }

    var body: some View {
        ScrollView {
            content
        }
        .background(AppTheme.background)
        .navigationTitle(viewModel.category.rawValue)
        .navigationBarTitleDisplayMode(.inline)

        .task {
            await viewModel.loadFirstPage()
        }

        .refreshable {
            await viewModel.reload()
        }


        .navigationDestination(for: Movie.self) { movie in
            MovieDetailView(movie: movie)
        }
    }

    @ViewBuilder
    private var content: some View {

        switch viewModel.state {

        case .idle, .loading:

            ProgressView()
                .frame(maxWidth: .infinity)
                .padding(.top, 60)

        case .success:

            LazyVGrid(
                columns: columns,
                spacing: 20
            ) {

                ForEach(viewModel.movies) { movie in

                    NavigationLink(value: movie) {

                        MoviePosterCard(
                            movie: movie,
                            width: 100,
                            height: 150
                        )
                    }
                    .buttonStyle(.plain)

                    .onAppear {
                        viewModel.loadNextPageIfNeeded(
                            currentItem: movie
                        )
                    }
                }
            }
            .padding()

            if viewModel.isLoadingNextPage {

                ProgressView()
                    .padding(.vertical, 20)
            }

        case .empty:

            ContentUnavailableView(
                "Film tapılmadı",
                systemImage: "film",
                description: Text(
                    "Bu kateqoriyada film yoxdur"
                )
            )
            .frame(
                maxWidth: .infinity,
                minHeight: 300
            )

        case .error(let message):

            ContentUnavailableView {

                Label(
                    "Xəta baş verdi",
                    systemImage: "exclamationmark.triangle"
                )

            } description: {

                Text(message)

            } actions: {

                Button("Yenidən cəhd et") {
                    Task {
                        await viewModel.reload()
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(.top, 40)
        }
    }
}

#Preview {
    NavigationStack {
        SeeAllView(category: .popular)
    }
}
