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
    
    func fetchUser(completion: @escaping (Result<User, Error>) -> Void) {
        let url = "\(baseURL)/"
        
        guard let token = UserDefaults.standard.string(forKey: "authToken") else {
            let error = NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Authentication token not found."])
            completion(.failure(error))
            return
        }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(token)",
            "Accept": "application/json"
        ]
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: User.self) { response in
                switch response.result {
                case .success(let user):
                    completion(.success(user))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func logout() {
        UserDefaults.standard.removeObject(forKey: "authToken")
        print("User successfully logged out and token removed.")
    }
}
