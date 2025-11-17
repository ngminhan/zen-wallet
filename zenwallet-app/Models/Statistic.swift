//
//  Statistic.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 12/11/25.
//

import Foundation

struct OverviewResponse: nonisolated Codable {
    let year: Int
    let month: Int
    let data: [FinancialOverviewItem]
}

struct FinancialOverviewItem: nonisolated Codable, Equatable {
    let bucket: String  
    let income: Double
    let expense: Double
    let balance: Double
}

struct CategoryResponse: nonisolated Codable {
    let year: Int
    let month: Int
    let total: Double
    let data: [ExpenseCategoryItem]
}

struct ExpenseCategoryItem: nonisolated Codable, Equatable {
    let category: String
    let amount: Double
    let percentage: Double
}
