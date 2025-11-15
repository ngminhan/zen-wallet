import Alamofire
import Foundation

final class AuthViewModel {
    private let baseURL = "http://localhost:3000/api/auth"
    
    func signup(name: String, email: String, password: String, completion: @escaping (Result<AuthResponse, Error>) -> Void) {
        let url = "\(baseURL)/signup"
        let parameters: [String: Any] = [
            "name": name,
            "email": email,
            "password": password
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: AuthResponse.self) { response in
                switch response.result {
                case .success(let user):
                    UserDefaults.standard.set(user.token, forKey: "authToken")
                    completion(.success(user))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func login(email: String, password: String, completion: @escaping (Result<AuthResponse, Error>) -> Void) {
        let url = "\(baseURL)/login"
        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .responseDecodable(of: AuthResponse.self) { response in
                switch response.result {
                case .success(let user):
                    UserDefaults.standard.set(user.token, forKey: "authToken")
                    completion(.success(user))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
