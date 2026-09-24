//
//  Movie.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 13.09.26.
//

import Foundation


struct MovieResult:  Codable, Equatable, Hashable {
    let page: Int
    let totalPages: Int
    let movies : [Movie]
}


struct Movie: Identifiable, Codable, Equatable, Hashable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let rating: Double
    let releaseDate: String?
    let runtimeMinutes: Int?
    let genreIds: [Int]
    
    var posterUrl : URL? {
        ImageURLBuilder.url(path: posterPath, size: .posterLarge)
    }
    var backdropUrl:URL? {
        ImageURLBuilder.url(path: backdropPath, size: .backdropLarge)
    }
    
    var runtimeText: String {
        guard let runtimeMinutes else { return "—" }
        return "\(runtimeMinutes) minutes"
    }
    
    var releaseYear : String {
        guard let releaseDate, releaseDate.count >= 4 else {return "-"}
        return String(releaseDate.prefix(4))
    }
    
    func genreNames(from genres:[Genre])-> String {
        genres.filter { genreIds.contains($0.id)}
            .map(\.name)
            .joined(separator: ", ")
    }
}
