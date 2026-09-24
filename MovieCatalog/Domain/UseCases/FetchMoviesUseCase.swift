//
//  FetchMoviesUseCase.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 13.09.26.
//

protocol FetchMoviesUseCaseProtocol {
    func execute(category:MovieCategory, page:Int) async throws -> MovieResult
}


final class FetchMoviesUseCase : FetchMoviesUseCaseProtocol{
    
    
    private let repository:MovieRepositoryProtocol
 
    init(repository: MovieRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(category: MovieCategory, page: Int) async throws -> MovieResult {
        try await repository.fetchMovies(category: category, page: page)
    }
  
  
    
    
}
