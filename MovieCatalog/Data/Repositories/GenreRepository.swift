//
//  GenreRepository.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 13.09.26.
//

final class GenreRepository : GenreRepositoryProtocol {
    private let networkService : NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    func fetchGenres() async throws -> [Genre] {
        let dto: GenreResponseDTO =  try await networkService.makeRequest(MovieEndpoint.genreList)
        return dto.genres.map {$0.toDomain()}
        
    }
    
    
}
