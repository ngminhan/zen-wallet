//
//  StatisticViewModel.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 12/11/25.
//

import Foundation
import Alamofire

final class StatisticsViewModel {

    var selectedYear: Int = Calendar.current.component(.year, from: Date())
    var selectedMonth: Int = Calendar.current.component(.month, from: Date())

    var overviewItems: [FinancialOverviewItem] = []
    var categoryItems: [ExpenseCategoryItem] = []

    private let baseURL = "http://127.0.0.1:3000/api/statistic"

    private var headers: HTTPHeaders {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            return ["Accept": "application/json"]
        }
        return [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
    }

    func fetchOverview(completion: @escaping () -> Void) {
        let url = "\(baseURL)?year=\(selectedYear)&month=\(selectedMonth)"

        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: OverviewResponse.self) { [weak self] res in
               
                
                switch res.result {
                case .success(let data):
                    self?.overviewItems = data.data
                case .failure(let err):
                    print("❌ Overview failed:", err.localizedDescription)
                }
                completion()
            }
    }

    func fetchCategory(completion: @escaping () -> Void) {
        let url = "\(baseURL)/category?year=\(selectedYear)&month=\(selectedMonth)"

        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: CategoryResponse.self) { [weak self] res in
                
                
                switch res.result {
                case .success(let data):
                    self?.categoryItems = data.data
                case .failure(let err):
                    print("❌ Category failed:", err.localizedDescription)
                }
                completion()
            }
    }
}

