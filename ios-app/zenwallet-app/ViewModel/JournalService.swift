//
//  JournalService.swift
//  zenwallet-app
//
//  Created by Nguyễn Minh An on 15/11/25.
//

import Foundation
import Alamofire

final class JournalService {
    
    static let shared = JournalService()
    private init() {}
    
    private let baseURL = "http://127.0.0.1:3000/api/journals"
    
    // MARK: - Headers
    private var headers: HTTPHeaders {
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            return ["Accept": "application/json"]
        }
        return [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
    }
    
    // MARK: - Fetch journal of specific date
    func fetchJournal(date: String, completion: @escaping (Result<JournalResponse, Error>) -> Void) {
        
        let params = ["date": date]
        
        AF.request(
            baseURL,
            method: .get,
            parameters: params,
            headers: headers
        )
        .cURLDescription { curl in
            print("🔍 CURL REQUEST FROM APP:")
            print(curl)
        }
        .validate(statusCode: 200..<300)
        .responseData { raw in
            if let data = raw.data {
                print("📥 RAW JSON FROM BACKEND:")
                print(String(data: data, encoding: .utf8) ?? "Invalid UTF8")
            }
        }
        .responseDecodable(of: JournalResponse.self) { response in
            
            switch response.result {
                
            case .success(let journal):
                completion(.success(journal))
                
            case .failure(let error):
                print("❌ Error fetching journal:", error)
                completion(.failure(error))
            }
        }
    }
    
    
    // MARK: - Create new journal (POST)
    func createJournal(_ request: JournalRequest, completion: @escaping (Result<JournalResponse, Error>) -> Void) {
        
        AF.request(
            baseURL,
            method: .post,
            parameters: request,
            encoder: JSONParameterEncoder.default,
            headers: headers
        )
        .validate(statusCode: 200..<300)
        .responseDecodable(of: JournalResponse.self) { response in
            
            switch response.result {
                
            case .success(let data):
                completion(.success(data))
                
            case .failure(let error):
                print("❌ Error creating journal:", error)
                completion(.failure(error))
            }
        }
    }
    
    
    // MARK: - Update journal (PUT)
    func updateJournal(_ request: JournalRequest, completion: @escaping (Result<JournalResponse, Error>) -> Void) {
        
        AF.request(
            baseURL,
            method: .put,
            parameters: request,
            encoder: JSONParameterEncoder.default,
            headers: headers
        )
        .validate(statusCode: 200..<300)
        .responseDecodable(of: JournalResponse.self) { response in
            
            switch response.result {
                
            case .success(let data):
                completion(.success(data))
                
            case .failure(let error):
                print("❌ Error updating journal:", error)
                completion(.failure(error))
            }
        }
    }
    
    
    // MARK: - Fetch list of journals in a month (for calendar)
    func fetchJournalList(month: Int, year: Int, completion: @escaping (Result<[JournalListItem], Error>) -> Void) {
        
        let params: [String: Any] = [
            "month": month,
            "year": year
        ]
        
        AF.request(
            "\(baseURL)/list",
            method: .get,
            parameters: params,
            headers: headers
        )
        .validate(statusCode: 200..<300)
        .responseDecodable(of: [JournalListItem].self) { response in
            
            switch response.result {
                
            case .success(let list):
                completion(.success(list))
                
            case .failure(let error):
                print("❌ Error fetching journal list:", error)
                completion(.failure(error))
            }
        }
    }
}
