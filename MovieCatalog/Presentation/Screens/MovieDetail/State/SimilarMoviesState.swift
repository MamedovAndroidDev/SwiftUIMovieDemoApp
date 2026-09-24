//
//  SimilarMoviesState.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 23.09.26.
//



enum SimilarMoviesState{
    case idle
    case loading
    
    case loaded(
        movies:[Movie],
        currentPage:Int,
        hasMore:Bool
    )
    case loadingMore(
        movies: [Movie],
        currentPage:Int
    )
    case error(
        movies:[Movie],
        message:String
    )
}
