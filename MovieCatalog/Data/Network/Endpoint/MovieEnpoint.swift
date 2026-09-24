//
//  MovieEnpoint.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 13.09.26.
//

import Foundation



protocol MovieEndpointProtocol {
    var path:String {get}
    var method:HTTPMethod {get}
    var queryItems:[URLQueryItem]? {get}
    var body : Data? {get}
}

enum MovieEndpoint : MovieEndpointProtocol {
    
    case movies(category: MovieCategory, page: Int)
    case search(query: String, page: Int)
    case discover(genreId: Int?, year: Int?, page: Int)
    case fetchSimilarMovies(id: Int, page: Int)
    case fetchCredits(id: Int)
    case movieDetail(id: Int)
    case genreList
    
    
    var path: String {
        switch self {
        case .movies(let category, _):
            switch category {
            case .nowPlaying: return "/movie/now_playing"
            case .upcoming: return "/movie/upcoming"
            case .topRated: return "/movie/top_rated"
            case .popular: return "/movie/popular"
            }
        case .search: return "/search/movie"
        case .discover: return "/discover/movie"
        case .movieDetail(let id): return "/movie/\(id)"
        case .genreList: return "/genre/movie/list"
        case .fetchSimilarMovies(id: let id, page: let page):
            return "/movie/\(id)/similar"
        case .fetchCredits(id: let id):
          return  "/movie/\(id)/credits"
        }
    }

    
    var method: HTTPMethod {
        .get
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .movies(_, let page):
            return [URLQueryItem(name: "page", value: "\(page)")]
        case .search(let query, let page):
            return [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "page", value: "\(page)"),
            ]
        case .discover(let genreId, let year, let page):
            var items = [URLQueryItem(name: "page", value: "\(page)")]
            if let genreId { items.append(URLQueryItem(name: "with_genres", value: "\(genreId)")) }
            if let year { items.append(URLQueryItem(name: "primary_release_year", value: "\(year)")) }
            return items
        case .movieDetail, .genreList:
            return nil
        case .fetchSimilarMovies(id: let id, page: let page):
           return [URLQueryItem(name: "page", value: "\(page)")]
        case .fetchCredits(id: let id):
            return nil
        }
    }
    
    var body: Data?  {  nil }
    
    
}

