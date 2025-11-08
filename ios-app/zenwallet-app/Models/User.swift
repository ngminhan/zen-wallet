//
//  User.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 7/11/25.
//

struct User: Codable {
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

