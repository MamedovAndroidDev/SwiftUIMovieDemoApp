//
//  WatchlistRepositoryProtocol.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 20.09.26.
//

// Ikonlar eyni olduqu ucun protocol yazilir normalda interface ve class ikonlar ferqli olur ve secilir fayli gorende
// Bezen impl ile implementasiyasi yazilir
protocol WatchlistRepositoryProtocol {
    func add(movie:Movie) async throws
    func remove(movieId:Int) async throws
    func getAll() async throws -> [Movie]
    func isSaved(movieId:Int) async -> Bool
}
