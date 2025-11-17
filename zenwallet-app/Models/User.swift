//
//  User.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 7/11/25.
//

struct User: nonisolated Codable {
    let userID: Int
    var name: String
    var email: String
    var photoURL: String?
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case name, email
        case photoURL = "photo_url"
        case createdAt = "created_at"
    }
}

struct AuthResponse: nonisolated Codable {
    let user_id: Int
    let name: String
    let email: String
    let token: String
}


