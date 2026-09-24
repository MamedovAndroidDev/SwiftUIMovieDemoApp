//
//  ImageURLBuilder.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 13.09.26.
//

import Foundation

enum ImageSize:String {
    case posterSmall = "w342"
    case posterLarge = "w500"
    
    case backdropSmall = "w780"
    case backdropLarge = "w1280"
    
    case actor = "w185"
    case original = "original"
}



enum ImageURLBuilder {
    static func url(path:String?,size:ImageSize)-> URL? {
        guard let path, !path.isEmpty else {return nil}
        let urlString = "\(APIConfig.imageBaseUrl)/\(size.rawValue)\(path)"
        return URL(string: urlString)
    }
}
