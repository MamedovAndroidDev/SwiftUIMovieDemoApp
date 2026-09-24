//
//  ManageWatchlistUseCase.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 20.09.26.
//

protocol ManageWatchlistUseCaseProtocol {
    func toggle(movie:Movie) async throws
    func getAll() async throws -> [Movie]
    func isSaved(movieId:Int) async -> Bool
}

final class ManageWatchlistUseCase : ManageWatchlistUseCaseProtocol {
    
    private let repository : WatchlistRepositoryProtocol
    
    init(repository: WatchlistRepositoryProtocol) {
        self.repository = repository
    }
    
    func toggle(movie: Movie) async throws {
        if await repository.isSaved(movieId: movie.id) {
           try  await repository.remove(movieId: movie.id)
        }else {
           try await  repository.add(movie: movie)
        }
    }
    
    func getAll() async throws -> [Movie] {
        try await repository.getAll()
    }
    
    func isSaved(movieId: Int) async -> Bool {
        await repository.isSaved(movieId: movieId)
    }
    
   
    
}
