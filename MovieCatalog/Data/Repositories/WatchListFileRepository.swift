//
//  WatchListFileRepository.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 20.09.26.
//
import Foundation
final class WatchListFileRepository: WatchlistRepositoryProtocol {
    
    private let fileURL: URL
    
    
    init() {
        if let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
            self.fileURL = documentsUrl.appendingPathComponent("watchlist.json")
        }else {
            self.fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("watchList.json")
        }
    }
    
    
    private func loadFromFile() -> [Movie]{
        guard let data = try? Data(contentsOf: fileURL) else {return [] }
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return (try? decoder.decode([Movie].self, from: data)) ?? []
    }
    
    
    private func saveToFile(movies: [Movie]) throws {
        let data = try JSONEncoder().encode(movies)
        try data.write(to: fileURL,options: .atomic)
    }
    
    func add(movie: Movie) async throws {
        var movies = loadFromFile()
        guard !movies.contains(where: {$0.id == movie.id}) else {return}
        movies.append(movie)
        try saveToFile(movies: movies)
    }
   
    
    func remove(movieId:Int) async throws {
        var movies = loadFromFile()
        movies.removeAll {$0.id == movieId }
        try saveToFile(movies: movies)
    }
    
    func getAll() async throws -> [Movie]{
        return loadFromFile()
    }
    
    func isSaved(movieId:Int) async -> Bool {
        let movies = loadFromFile()
        return movies.contains(where: { $0.id == movieId})
    }
    
   
}
