//
//  WatchlistRepository.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 20.09.26.
//
import SwiftData
import Foundation

final class WatchlistRepository : WatchlistRepositoryProtocol {
    
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    func add(movie: Movie) async throws {
        context.insert(MovieEntity(from: movie))
        try context.save()
    }
    
    func remove(movieId: Int) async throws {
        let descriptor = FetchDescriptor<MovieEntity>(predicate:  #Predicate { $0.id == movieId })
        if let saved = try context.fetch(descriptor).first {
            context.delete(saved)
            try context.save()
        }
   
     
    }
    
    func getAll() async throws -> [Movie] {
        let descriptor = FetchDescriptor<MovieEntity>()
        return try context.fetch(descriptor).map {$0.toDomain()}
    }
    
    func isSaved(movieId: Int) async -> Bool {
        let descriptor = FetchDescriptor<MovieEntity>(predicate:  #Predicate { $0.id == movieId })
        return ((try? context.fetch(descriptor).first ?? nil) != nil )
    }
    
    
}
