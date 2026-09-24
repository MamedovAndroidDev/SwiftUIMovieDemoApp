//
//  GenreRepositoryProtocol.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 13.09.26.
//

protocol GenreRepositoryProtocol {
    func fetchGenres() async throws -> [Genre]
}
