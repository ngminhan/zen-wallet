//
//  HomeViewModel.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 9/11/25.
//

import Foundation

final class HomeViewModel {
    private var allTransactions: [Transaction] = []
    private(set) var filteredTransactions: [Transaction] = []
    private(set) var totalIncome: Double = 0
    private(set) var totalExpense: Double = 0
    
    private let calendar = Calendar.current
    
    func updateTransactions(_ transactions: [Transaction], filter: TimeFilter = .month) {
        self.allTransactions = transactions
        applyFilter(filter)
    }
    
    func applyFilter(_ filter: TimeFilter) {
        let now = Date()
        
        filteredTransactions = allTransactions.filter {
            switch filter {
            case .day:
                return calendar.isDate($0.createdAt, inSameDayAs: now)
            case .week:
                return calendar.isDate($0.createdAt, equalTo: now, toGranularity: .weekOfYear)
            case .month:
                return calendar.isDate($0.createdAt, equalTo: now, toGranularity: .month)
            case .year:
                return calendar.isDate($0.createdAt, equalTo: now, toGranularity: .year)
            }
        }
        
        totalIncome = filteredTransactions
            .filter { $0.type == .income }
            .reduce(0) { $0 + $1.amount }
        
        totalExpense = filteredTransactions
            .filter { $0.type == .expense }
            .reduce(0) { $0 + $1.amount }
    }
}

enum TimeFilter: CaseIterable {
    case day, week, month, year
}
