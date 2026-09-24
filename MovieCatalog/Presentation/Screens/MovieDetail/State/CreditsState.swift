//
//  CreditsState.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 23.09.26.
//


enum CreditsState {
    case idle
    case loading
    case loaded(
        director:CrewMember?,
        cast: [CastMember]
    )
    case error
}



