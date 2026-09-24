//
//  MovieResponseDto.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 13.09.26.
//
import Foundation


struct MovieResponseDto : Decodable {
    let page: Int
    let totalPages: Int
    let totalResults: Int
    let results : [MovieDto]
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct MovieDto:Decodable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let voteAverage: Double
    let releaseDate: String?
    let runtime: Int?
    let genreIds: [Int]?
    
    enum CodingKeys: String , CodingKey {
        case id, title, overview, runtime
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
        case genreIds = "genre_ids"
    }
}
extension MovieDto {
    func toDomain() -> Movie {
        Movie(
            id: id, title: title, overview: overview,
            posterPath: posterPath, backdropPath: backdropPath,
            rating: voteAverage, releaseDate: releaseDate,
            runtimeMinutes: runtime, genreIds: genreIds ?? []
        )
    }
}

extension MovieResponseDto  {
    func toDomain() -> MovieResult {
        MovieResult(
            page: page,
            totalPages: totalPages,
            movies: results.map { $0.toDomain()},
            
        )
    }
}
