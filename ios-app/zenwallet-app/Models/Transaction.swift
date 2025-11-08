//
//  TransactionModel.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 7/11/25.
//

import Foundation

struct Transaction: nonisolated Codable {
    let transactionID: Int
    let userID: Int
    let type: TransactionType
    var category: Category
    var amount: Double
    var note: String?
    var createdAt: Date

    enum CodingKeys: String, CodingKey {
        case transactionID = "transaction_id"
        case userID = "user_id"
        case type, category, amount, note
        case createdAt = "created_at"
    }
}

enum Category: String, Codable, Sendable {
    case essential = "ESSENTIAL"
    case nonEssential = "NON_ESSENTIAL"
    case spiritual = "SPIRITUAL"
    case unexpected = "UNEXPECTED"
}

enum TransactionType: String, Codable, Sendable {
    case income = "INCOME"
    case expense = "EXPENSE"
}
