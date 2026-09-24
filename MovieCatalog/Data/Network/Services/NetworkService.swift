//
//  NetworkService.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 13.09.26.
//

import Foundation
// Adda protocol yazilma sebebi class ve protocol ayird etmek ucun ikonu yoxdur baxarken eyni gosterilir
// Bezi diller evveli I yazilir bezirlerinde bele yazilir. Normalda class ve interface ikonlari ferqlidir

protocol NetworkServiceProtocol {
    func makeRequest<T:Decodable> (_ endpoint:MovieEndpoint) async throws -> T
}


final class DefaultNetworkService: NetworkServiceProtocol {
    private let session: URLSession
    private let decoder : JSONDecoder
    
    init(session: URLSession = .shared, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    
    
    func makeRequest<T>(_ endpoint: MovieEndpoint) async throws -> T where T : Decodable {
        var components = URLComponents(string: APIConfig.baseURl + endpoint.path)
        components?.queryItems = endpoint.queryItems
    
        
        guard let url = components?.url else { throw NetworkError.invalidUrl}
        
        let apiKeyQueryItem = URLQueryItem(name: "api_key", value: APIConfig.apiKey)
        
       
        if components?.queryItems != nil {
            components?.queryItems?.append(apiKeyQueryItem)
        } else {
            components?.queryItems = [apiKeyQueryItem]
        }
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer \(APIConfig.accessToken)", forHTTPHeaderField: "Authorization")
    
        
        let data:Data
        let response: URLResponse
        
        do {
           // print(APIConfig.accessToken)
            (data,response) = try await session.data(for: request)
        
        }catch {
            throw NetworkError.noInternetConnection
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        switch httpResponse.statusCode {
        case 200...299:
            do {
                return try decoder.decode(T.self, from: data)
            }catch {
                throw NetworkError.decodingError
            }
        case 404:
            throw NetworkError.notFound
        case 401:
            throw NetworkError.unauthorized
        default:
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
    }
    
    
}
