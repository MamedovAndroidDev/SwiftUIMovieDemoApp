//
//  GenreResponseDto.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 13.09.26.
//

struct GenreResponseDTO: Decodable {
    let genres: [GenreDTO]
}

struct GenreDTO: Decodable {
    let id: Int
    let name: String
}

extension GenreDTO {
    func toDomain() -> Genre {
        Genre(id: id, name: name)
    }
}
