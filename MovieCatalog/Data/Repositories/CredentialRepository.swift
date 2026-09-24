//
//  CredentialRepository.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 23.09.26.
//


final class CredentialRepository : CredentialRepositoryProtocol {
    
    
    private let networkService : NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchCredits(id: Int) async throws -> Credits {
        let dto: CreditsDTO =  try await networkService.makeRequest(MovieEnpoint.fetchCredits(id: id))
        return dto.toDomain()
    }
   
    
    
}
