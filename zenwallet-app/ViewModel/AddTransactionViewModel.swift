//
//  AddTransactionViewModel.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 10/11/25.
//

import Foundation

final class AddTransactionViewModel {
    
    func addTransaction(
        type: String,
        category: String?,
        amount: Double,
        note: String?,
        createdAt: Date?,
        completion: @escaping (Result<Transaction, Error>) -> Void
    ) {
        let finalDate = createdAt ?? Date()
        
        TransactionService.shared.addTransaction(
            type: type,
            category: category,
            amount: amount,
            note: note,
            createdAt: finalDate
        ) { result in
            switch result {
            case .success(let transaction):
                completion(.success(transaction))
            case .failure(let error):
                print("Failed to add transaction:", error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
}
