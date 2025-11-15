//
//  Goal.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 11/11/25.
//

import Foundation

struct Goal: nonisolated Codable {
    let goalID: Int
    let userID: Int?
    let year: Int
    let month: Int
    var amount: Double
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case goalID = "goal_id"
        case userID = "user_id"
        case year
        case month
        case amount
        case createdAt = "created_at"
    }
}

struct ProgressData: nonisolated Codable {
    let goalAmount: Double
    let totalIncome: Double
    let totalExpense: Double
    let saving: Double
    let progress: Double
    let targetPace: Double
    
    enum CodingKeys: String, CodingKey {
        case goalAmount = "goal_amount"
        case totalIncome = "total_income"
        case totalExpense = "total_expense"
        case saving
        case progress
        case targetPace = "target_pace"
    }
}
