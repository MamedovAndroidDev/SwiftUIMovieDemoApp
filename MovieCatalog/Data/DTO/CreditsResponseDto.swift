//
//  CreditsResponseDto.swift
//  MovieCatalog
//
//  Created by Ayaz Memmedov on 22.09.26.
//

// MARK: - GET /movie/{id}/credits

struct CreditsDTO: Decodable {
    let id: Int
    let cast: [CastMemberDTO]
    let crew: [CrewMemberDTO]
}

struct CastMemberDTO: Decodable {
    let id: Int
    let name: String
    let character: String
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id, name, character
        case profilePath = "profile_path"
    }
}

struct CrewMemberDTO: Decodable {
    let id: Int
    let name: String
    let job: String
    let department: String
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case id, name, job, department
        case profilePath = "profile_path"
    }
}
extension CastMemberDTO {
    func toDomain() -> CastMember {
        CastMember(id: id, name: name, character: character, profilePath: profilePath)
    }
}

extension CrewMemberDTO {
    func toDomain() -> CrewMember {
        CrewMember(id: id, name: name, job: job, department: department, profilePath: profilePath)
    }
}

extension CreditsDTO {
    func toDomain() -> Credits {
        let cast = cast.map {$0.toDomain()}
        let crew = crew.map {$0.toDomain()}
        return Credits(cast: cast, crew: crew)
        
    }
}


   

   


