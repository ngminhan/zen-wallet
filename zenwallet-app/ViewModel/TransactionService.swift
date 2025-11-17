//
//  TransactionService.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 7/11/25.
//

import Foundation
import Alamofire

class TransactionService {
    static let shared = TransactionService()
    private init() {}
    
    private let baseURL = "http://127.0.0.1:3000/api/transactions"
    
    private var headers: HTTPHeaders {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            return ["Accept": "application/json"]
        }
        return [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
    }
    
    func fetchTransactions(completion: @escaping (Result<[Transaction], Error>) -> Void) {
        AF.request(baseURL, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [Transaction].self, decoder: Transaction.decoder) { response in
                switch response.result {
                case .success(let transactions):
                    completion(.success(transactions))
                case .failure(let error):
                    print("Fetch failed:", error.localizedDescription)
                    completion(.failure(error))
                }
            }
    }
    
    func addTransaction(
        type: String,
        category: String?,
        amount: Double,
        note: String?,
        createdAt: Date,
        completion: @escaping (Result<Transaction, Error>) -> Void
    ) {
        let paramsOptional: [String: Any?] = [
            "type": type,
            "category": category,
            "amount": amount,
            "note": note,
            "date": createdAt.toUTCString()
        ]
        
        let params = paramsOptional.compactMapValues { $0 }
        
        AF.request(baseURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Transaction.self, decoder: Transaction.decoder) { response in
                switch response.result {
                case .success(let transaction):
                    completion(.success(transaction))
                case .failure(let error):
                    print("Add failed:", error.localizedDescription)
                    completion(.failure(error))
                }
            }
    }
    
    func updateTransaction(
        id: Int,
        type: String,
        category: String?,
        amount: Double,
        note: String?,
        createdAt: Date?,
        completion: @escaping (Result<Transaction, Error>) -> Void
    ) {
        let url = "\(baseURL)/\(id)"
        
        let paramsOptional: [String: Any?] = [
            "type": type,
            "category": category,
            "amount": amount,
            "note": note,
            "date": createdAt?.toUTCString()
        ]
        
        let params = paramsOptional.compactMapValues { $0 }
        
        AF.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Transaction.self, decoder: Transaction.decoder) { response in
                switch response.result {
                case .success(let updatedTransaction):
                    completion(.success(updatedTransaction))
                case .failure(let error):
                    print("Update failed:", error.localizedDescription)
                    completion(.failure(error))
                }
            }
    }
    
    func deleteTransaction(id: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = "\(baseURL)/\(id)"
        AF.request(url, method: .delete, headers: headers)
            .validate(statusCode: 200..<300)
            .response { response in
                switch response.result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    print("Delete failed:", error.localizedDescription)
                    completion(.failure(error))
                }
            }
    }
}
