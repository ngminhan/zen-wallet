//
//  TransactionDetailViewModel.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 11/11/25.
//

import Foundation

final class TransactionDetailViewModel {

    var transaction: Transaction

    init(transaction: Transaction) {
        self.transaction = transaction
    }

    func updateTransaction(
            type: String,
            category: String?,
            amount: Double,
            note: String?,
            createdAt: Date?,
            completion: @escaping (Result<Transaction, Error>) -> Void
        ) {
        TransactionService.shared.updateTransaction(
            id: transaction.transactionID,
            type: type,
            category: category,
            amount: amount,
            note: note,
            createdAt: createdAt
        ) { result in
            switch result {
            case .success(let updated):
                self.transaction = updated
                completion(.success(updated))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func deleteTransaction(completion: @escaping (Result<Void, Error>) -> Void) {
        TransactionService.shared.deleteTransaction(id: transaction.transactionID) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
