//
//  MovieEntity.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 13.09.26.
//
import SwiftData

@Model
final class MovieEntity {
    var id: Int
    var title: String
    var overview: String
    var posterPath: String?
    var backdropPath: String?
    var rating: Double
    var releaseDate: String?
    var runtimeMinutes: Int?
    var genreIds: [Int]

    init(from movie: Movie) {
        self.id = movie.id
        self.title = movie.title
        self.overview = movie.overview
        self.posterPath = movie.posterPath
        self.backdropPath = movie.backdropPath
        self.rating = movie.rating
        self.releaseDate = movie.releaseDate
        self.runtimeMinutes = movie.runtimeMinutes
        self.genreIds = movie.genreIds
    }

    func toDomain() -> Movie {
        Movie(id: id, title: title, overview: overview, posterPath: posterPath,
              backdropPath: backdropPath, rating: rating, releaseDate: releaseDate,
              runtimeMinutes: runtimeMinutes, genreIds: genreIds)
    }
}
