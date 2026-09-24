//
//  Credits.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 22.09.26.
//

import Foundation


struct Credits {
    let cast: [CastMember]
    let crew: [CrewMember]

    var director: CrewMember? {
        crew.first { $0.job == "Director" }
    }
}

struct CastMember: Identifiable, Hashable {
    let id: Int
    let name: String
    let character: String
    let profilePath: String?

    var profileURL: URL? {
        guard let profilePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w185\(profilePath)")
    }
}
struct CrewMember: Identifiable, Hashable {
    let id: Int
    let name: String
    let job: String
    let department: String
    let profilePath: String?
    
    var profileURL: URL? {
        guard let profilePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w185\(profilePath)")
    }
}
