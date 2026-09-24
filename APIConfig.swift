//
//  APIConfig.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 21.09.26.
//

import Foundation

enum APIConfig {
    
    
//    static var accessToken :String {
//        Bundle.main.object(forInfoDictionaryKey: "ACCESS_TOKEN") as? String ?? ""
//    }
    
//    static var apiKey : String? {
//        Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String ?? ""
//    }
    static let apiKey:String? = "6039fbed431b328883864921a1080884"
    
    static let accessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2MDM5ZmJlZDQzMWIzMjg4ODM4NjQ5MjFhMTA4MDg4NCIsIm5iZiI6MTc4OTA4NzM0Ni41Niwic3ViIjoiNmFhMzRlNzIwNDc5NjdjYmQ2OGNlNWM2Iiwic2NvcGVzIjpbImFwaV9yZWFkIl0sInZlcnNpb24iOjF9.Ln36sZbiaq7UtLuDZe3WvTAEu6FzOcSs7vbMePb5gGE"

    static let baseURl = "https://api.themoviedb.org/3"
    static let imageBaseUrl = "https://image.tmdb.org/t/p/"
}
