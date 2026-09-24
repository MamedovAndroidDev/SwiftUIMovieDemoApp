//
//  CredentialRepositoryProtocol.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 22.09.26.
//

protocol CredentialRepositoryProtocol {
    func fetchCredits(id: Int) async throws -> Credits
  
}
