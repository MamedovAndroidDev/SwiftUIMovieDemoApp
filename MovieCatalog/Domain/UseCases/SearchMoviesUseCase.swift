//
//  SearchMoviesUseCase.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 13.09.26.
//

protocol SearchMoviesUseCaseProtocol {
    
    func execute(query:String, genreId: Int?, year: Int?) async throws -> [Movie]
}

final class SearchMoviesUseCase : SearchMoviesUseCaseProtocol {
    
    private let repository : MovieRepositoryProtocol
    
    init(repository: MovieRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(query: String, genreId: Int?, year: Int?) async throws -> [Movie] {
        return try await repository.searchMovies(querry: query, genreId: genreId, year: year)
    }
    
    
}
