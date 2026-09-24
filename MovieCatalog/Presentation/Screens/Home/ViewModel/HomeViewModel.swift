//
//  HomeViewModel.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 13.09.26.
//
import Observation
import Foundation


@MainActor
@Observable
final class HomeViewModel {

    var popularState: SectionState = .idle
    var topRatedState: SectionState = .idle
    var upcomingState: SectionState = .idle
    var nowPlayingState: SectionState = .idle

    private let useCase: FetchMoviesUseCaseProtocol

    private var loadTask: Task<Void, Never>?

    init(useCase: FetchMoviesUseCaseProtocol) {
        self.useCase = useCase
    }

    func loadAll() {
        loadTask?.cancel()

        loadTask = Task { [weak self] in
            await self?.loadAllSections()
        }
    }

    func refresh() async {
        loadTask?.cancel()
        await loadAllSections()
    }

    func cancelLoading() {
        loadTask?.cancel()
        loadTask = nil
    }

    func reload(_ category: MovieCategory) {
        Task { [weak self] in
            await self?.load(category)
        }
    }

    private func loadAllSections() async {
        await withTaskGroup(of: Void.self) { group in

            for category in MovieCategory.allCases {
                group.addTask { [weak self] in
                    await self?.load(category)
                }
            }
        }
    }

    private func load(_ category: MovieCategory) async {

        setState(.loading, for: category)

        do {
            let response = try await useCase.execute(
                category: category,
                page: 1
            )

            guard !Task.isCancelled else { return }

            setState(
                response.movies.isEmpty
                    ? .empty
                    : .success(response.movies),
                for: category
            )

        } catch {

            guard !Task.isCancelled else { return }

            setState(
                .error(error.localizedDescription),
                for: category
            )
        }
    }

    private func setState(
        _ state: SectionState,
        for category: MovieCategory
    ) {
        switch category {
        case .popular:
            popularState = state

        case .topRated:
            topRatedState = state

        case .upcoming:
            upcomingState = state

        case .nowPlaying:
            nowPlayingState = state
        }
    }
}

enum SectionState {
    case idle
    case loading
    case success ([Movie])
    case empty
    case error(String)
}



