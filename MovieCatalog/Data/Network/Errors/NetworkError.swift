//
//  NetworkError.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 13.09.26.
//
import Foundation

enum NetworkError : Error {
    case invalidUrl
    case invalidResponse
    case unauthorized
    case notFound
    case serverError(statusCode:Int)
    case decodingError
    case noInternetConnection
    case unknown (String)
}

extension NetworkError : LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return "URL sehvdir"
        case .invalidResponse:
            return "Serverden duzgun cavab gelmir"
        case .unauthorized:
            return "Sessiya bitdi , yeniden daxil olun"
        case .notFound:
            return "Axtardiqiniz melumat tapilmadi"
        case .serverError(statusCode: let statusCode):
            return "Server xetasi bas verdi \(statusCode)"
        case .decodingError:
            return "Melumat oxuyarken xeta bas verdi"
        case .noInternetConnection:
           return "intetnet elaqesi yoxdur"
        case .unknown(let message):
            return message
        }
    }
}
