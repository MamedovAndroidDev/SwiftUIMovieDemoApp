//
//  FetchGenresUseCase.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 13.09.26.
//

protocol FetchGenresUseCaseProtocol {
    func execute() async throws -> [Genre]
}

final class FetchGenresUseCase : FetchGenresUseCaseProtocol{
    private let repository: GenreRepositoryProtocol
    private var catchedGenre:[Genre]?
    init(repository: GenreRepositoryProtocol) {
        self.repository = repository
    }
    func execute() async throws -> [Genre] {
        if let catchedGenre {
            return catchedGenre
        }else {
            return try await repository.fetchGenres()
        }
    }
    
    
}
