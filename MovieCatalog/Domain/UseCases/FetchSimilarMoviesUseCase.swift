//
//  FetchSimilarMoviesUseCase.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 22.09.26.
//


protocol FetchSimilarMoviesUseCaseProtocol {
    func execute(id:Int, page:Int) async throws -> MovieResult
}


final class FetchSimilarMoviesUseCase : FetchSimilarMoviesUseCaseProtocol{
    
    
    private let repository:MovieRepositoryProtocol
 
    init(repository: MovieRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(id: Int, page: Int) async throws -> MovieResult {
        try await repository.fetchSimilarMovies(id: id, page: page)
    }
  
  
    
    
}
