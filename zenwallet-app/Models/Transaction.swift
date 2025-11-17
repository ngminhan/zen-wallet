//
//  TransactionModel.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 7/11/25.
//

import UIKit

struct Transaction: nonisolated Codable, Sendable {
    let transactionID: Int
    let userID: Int
    let type: TransactionType
    var category: Category?
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

extension Transaction {
    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            
            let isoFormatterWithMs = ISO8601DateFormatter()
            isoFormatterWithMs.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let date = isoFormatterWithMs.date(from: dateStr) {
                return date
            }
            
            let isoFormatter = ISO8601DateFormatter()
            isoFormatter.formatOptions = [.withInternetDateTime]
            if let date = isoFormatter.date(from: dateStr) {
                return date
            }
            
            let sqlFormatter = DateFormatter()
            sqlFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            sqlFormatter.locale = Locale(identifier: "en_US_POSIX")
            sqlFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            if let date = sqlFormatter.date(from: dateStr) {
                return date
            }
            
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid date format: \(dateStr)"
            )
        }
        return decoder
    }
}



enum Category: String, Codable, Sendable, CaseIterable {
    case essential = "ESSENTIAL"
    case nonEssential = "NON_ESSENTIAL"
    case spiritual = "SPIRITUAL"
    case unexpected = "UNEXPECTED"
    
    var icon: UIImage {
        switch self {
        case .essential:
            return .essential
        case .nonEssential:
            return .nonEssential
        case .spiritual:
            return .spiritual
        case .unexpected:
            return .unexpected 
        }
    }
    
    var displayText: String {
        switch self {
        case .essential:
            return "Essential"
        case .nonEssential:
            return "Non-essential"
        case .spiritual:
            return "Spiritual"
        case .unexpected:
            return "Unexpected"
        }
    }
}

enum TransactionType: String, Codable, Sendable {
    case income = "INCOME"
    case expense = "EXPENSE"
    
    var displayText: String {
        switch self {
        case .income:
            return "Income"
        case .expense:
            return "Expense"
        }
    }
    
    var themeColor: UIColor {
        switch self {
        case .income:
            return .lightBlue
        case .expense:
            return .salmon
        }
    }
}
