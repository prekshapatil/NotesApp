//
//  Note.swift
//  WA7_Patil_6279
//
//  Created by Preksha Patil on 28/10/24.
//

struct Note: Decodable {
    let id: String
    let text: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case text
    }
}

struct NotesResponse: Decodable {
    let notes: [Note]
}

struct UserProfile: Codable {
    let id: String
    let name: String
    let email: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case email
    }
}

struct LoginResponse: Decodable {
    let auth: Bool
    let token: String?
}
