//
//  HomeViewModel.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 7/11/25.
//

import Foundation
import Alamofire

class TransactionService {
    static let shared = TransactionService()
    private init() {}

    private let baseURL = "https://zen-wallet.onrender.com"

    func fetchTransactions(completion: @escaping (Result<[Transaction], Error>) -> Void) {
        let url = "\(baseURL)/transactions"

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        AF.request(url)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: [Transaction].self, decoder: decoder) { response in
                switch response.result {
                case .success(let transactions):
                    completion(.success(transactions))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}


