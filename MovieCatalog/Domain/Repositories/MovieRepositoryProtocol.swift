//
//  MovieRepositoryProtocol.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 13.09.26.
//

protocol MovieRepositoryProtocol {
    func fetchMovies(category:MovieCategory, page:Int) async throws -> MovieResult
    func fetchSimilarMovies(id: Int, page: Int) async throws -> MovieResult
    func searchMovies(querry:String,genreId: Int?, year: Int?) async throws -> [Movie]
   
}
