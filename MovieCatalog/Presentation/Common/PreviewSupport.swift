//
//  PreviewSupport.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 23.09.26.
//

final class PreviewWatchlistUseCase: ManageWatchlistUseCaseProtocol {
    var saved: [Movie]
    init(preloaded: [Movie] = []) { saved = preloaded }
    
    func toggle(movie: Movie) async throws {
        if saved.contains(where: { $0.id == movie.id }) {
            saved.removeAll { $0.id == movie.id }
        } else {
            saved.append(movie)
        }
    }
    func getAll() async throws -> [Movie] { saved }
    func isSaved(movieId: Int) async -> Bool { saved.contains { $0.id == movieId } }
}

struct PreviewFetchGenresUseCase: FetchGenresUseCaseProtocol {
    let genres: [Genre]
    init(genres: [Genre] = Genre.mockList) { self.genres = genres }
    func execute() async throws -> [Genre] { genres }
}

struct PreviewSearchUseCase: SearchMoviesUseCaseProtocol {
    let result: Result<[Movie], Error>
    func execute(query: String, genreId: Int?, year: Int?) async throws -> [Movie] { try result.get() }
}

struct PreviewFetchMoviesUseCase: FetchMoviesUseCaseProtocol {
    let result: Result<MovieResult, Error>
    func execute(category: MovieCategory, page: Int) async throws -> MovieResult {
        try result.get()
    }
    
}


extension Genre {
    static let mockList: [Genre] = [
        Genre(id: 28, name: "Action"),
        Genre(id: 35, name: "Comedy"),
        Genre(id: 18, name: "Drama"),
        Genre(id: 27, name: "Horror"),
        Genre(id: 878, name: "Sci-Fi"),
        Genre(id: 10749, name: "Romance")
    ]
}
extension Movie {
    static let mock1 = Movie(
        id: 1, title: "Jurassic World", overview: "Dinozavrlar geri qayıdır və insanlığı təhdid edir. Yeni park açılır, amma nəzarətdən çıxan genetik təcrübələr fəlakətə yol açır.",
        posterPath: nil, backdropPath: nil, rating: 9.5,
        releaseDate: "2019-06-01", runtimeMinutes: 139, genreIds: [28]
    )
    static let mock2 = Movie(
        id: 2, title: "Spider-Man: No Way Home", overview: "Spider-Man multiverslə üzləşir, keçmiş düşmənlər başqa reallıqlardan geri qayıdır və Peter Parker həyatının ən çətin seçimi ilə üzləşir.",
        posterPath: nil, backdropPath: nil, rating: 8.5,
        releaseDate: "2021-12-01", runtimeMinutes: 148, genreIds: [28]
    )
    static let mockList = [mock1, mock2]
}

extension MovieResult {
    static let mockResult =  MovieResult(page: 1, totalPages: 200, movies: Movie.mockList)
    static let emptyResult =  MovieResult(page: 1, totalPages: 200, movies:[])
}
