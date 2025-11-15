//
//  GoalsViewModel.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 11/11/25.
//

import Foundation
import Alamofire

final class GoalsViewModel {
    var selectedMonth: Int
    var selectedYear: Int
    var goal: Goal?
    var progressData: ProgressData?
    
    init(selectedMonth: Int, selectedYear: Int) {
        self.selectedMonth = selectedMonth
        self.selectedYear = selectedYear
    }
    
    private let baseURL = "http://127.0.0.1:3000/api/goals"
    
    private var headers: HTTPHeaders {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            return ["Accept": "application/json"]
        }
        return [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
    }
    
    // Fetch goal
    func fetchGoal(completion: @escaping (Result<Goal, Error>) -> Void) {
        let params = ["year": selectedYear, "month": selectedMonth]
        AF.request(baseURL, method: .get, parameters: params, headers: headers)
            .validate()
            .responseDecodable(of: Goal.self) { response in
                switch response.result {
                case .success(let goal):
                    self.goal = goal
                    completion(.success(goal))
                case .failure(let error):
                    completion(.failure(error))
                    print("error: \(error).")
                }
            }
    }
    
    // Update goal
    func updateGoal(amount: Double, completion: @escaping (Result<Goal, Error>) -> Void) {
        let body: [String: Any] = ["year": selectedYear, "month": selectedMonth, "amount": amount]
        AF.request(baseURL, method: .put, parameters: body, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: Goal.self) { response in
                switch response.result {
                case .success(let goal):
                    self.goal = goal
                    completion(.success(goal))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    // Fetch progress
    func fetchProgress(completion: @escaping (Result<ProgressData, Error>) -> Void) {
        let params = ["year": selectedYear, "month": selectedMonth]
        AF.request("\(baseURL)/progress", method: .get, parameters: params, headers: headers)
            .validate()
            .responseDecodable(of: ProgressData.self) { response in
                switch response.result {
                case .success(let progress):
                    self.progressData = progress
                    completion(.success(progress))
                    print("success: \(progress)")
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
