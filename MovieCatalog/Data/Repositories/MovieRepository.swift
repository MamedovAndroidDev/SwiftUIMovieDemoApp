//
//  MovieRepository.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 13.09.26.
//


final class MovieRepository : MovieRepositoryProtocol {
    
   
    
    
    private let networkService : NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    
    func fetchSimilarMovies(id: Int, page: Int) async throws -> MovieResult {
        let dto : MovieResponseDto = try await networkService.makeRequest(MovieEnpoint.fetchSimilarMovies(id: id, page: page))
        return dto.toDomain()
    }
    
    
    func fetchMovies(category: MovieCategory, page: Int) async throws -> MovieResult {
        let dto : MovieResponseDto = try await networkService.makeRequest(MovieEnpoint.movies(category: category, page: page))
        return dto.toDomain()
    }
    
    
    func searchMovies(querry: String, genreId: Int?, year: Int?) async throws -> [Movie] {
        if querry.trimmingCharacters(in: .whitespaces).isEmpty {
            let dto: MovieResponseDto = try await networkService.makeRequest(MovieEnpoint.discover(genreId: genreId, year: year, page: 1))
            return dto.results.map { $0.toDomain() }
            
        }else {
            let dto:MovieResponseDto = try await networkService.makeRequest(MovieEnpoint.search(query: querry, page: 1))
            var movies = dto.results.map { $0.toDomain() }
            if let genreId { movies = movies.filter{$0.genreIds.contains(genreId)} }
            if let year { movies = movies.filter{$0.releaseYear == "\(year)"} }
            return movies
        }
    }
        
        
        
        
        
        
        
        
    
    
}
