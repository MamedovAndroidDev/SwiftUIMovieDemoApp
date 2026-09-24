//
//  FetchCreditsUseCase.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 23.09.26.
//

protocol FetchCreditsUseCaseProtocol {
    func execute(movieId: Int) async throws -> Credits
}
final class FetchCreditsUseCase: FetchCreditsUseCaseProtocol {
    private let repository:CredentialRepositoryProtocol
 
    init(repository: CredentialRepositoryProtocol) {
        self.repository = repository
    }
    func execute(movieId: Int) async throws -> Credits {
        try await repository.fetchCredits(id: movieId)
    }
}
