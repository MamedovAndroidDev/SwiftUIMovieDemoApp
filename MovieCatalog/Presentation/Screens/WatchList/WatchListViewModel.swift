//
//  WatchListViewModel.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 20.09.26.
//
import Observation
@Observable
@MainActor
final class WatchListViewModel {
    enum State: Equatable {
        case idle, loading, loaded([Movie]), empty, error(String)
    }

    private(set) var state: State = .idle
    private(set) var genres: [Genre] = []

    private let useCase: ManageWatchlistUseCaseProtocol
    private let fetchGenresUseCase: FetchGenresUseCaseProtocol

    init(useCase: ManageWatchlistUseCaseProtocol, fetchGenresUseCase: FetchGenresUseCaseProtocol) {
        self.useCase = useCase
        self.fetchGenresUseCase = fetchGenresUseCase
    }

    func loadWatchlist() {
        Task {
            state = .loading
            async let genresResult = (try? fetchGenresUseCase.execute()) ?? []
            do {
                let movies = try await useCase.getAll()
                genres = await genresResult
                state = movies.isEmpty ? .empty : .loaded(movies)
            } catch {
                genres = await genresResult
                state = .error("Watch list yüklənmədi")
            }
        }
    }
}
