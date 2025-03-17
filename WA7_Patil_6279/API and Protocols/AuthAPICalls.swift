//
//  AuthAPICalls.swift
//  WA7_Patil_6279
//
//  Created by Preksha Patil on 28/10/24.
//

import Foundation
import Alamofire

class AuthAPICalls {
    
    // Login function
    func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = APIConfigs.authBaseURL + "login"
        let parameters: [String: String] = [
            "email": email,
            "password": password
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default)
            .responseData { response in
                if let statusCode = response.response?.statusCode {
                    print("Login Response Status Code:", statusCode)
                    
                    switch response.result {
                    case .success(let data):
                        print("Login Response Data:", String(data: data, encoding: .utf8) ?? "No response data")
                        
                        if statusCode == 200 {
                            if let token = self.parseAuthToken(from: data) {
                                completion(.success(token))
                            } else {
                                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response structure."])))
                            }
                        } else {
                            completion(.failure(NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Invalid email or password."])))
                        }
                    case .failure(let error):
                        print("Login error:", error)
                        completion(.failure(error))
                    }
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No response from server."])))
                }
            }
    }
    
    func register(name: String, email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = APIConfigs.authBaseURL + "register"
        let parameters: [String: String] = [
            "name": name,
            "email": email,
            "password": password
        ]
        
        print("Register request data: \(parameters)") // Log the request data

        AF.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default)
            .responseData { response in
                let statusCode = response.response?.statusCode
                print("Register Response Status Code:", statusCode ?? "No status code")
                
                switch response.result {
                case .success(let data):
                    print("Register Response Data:", String(data: data, encoding: .utf8) ?? "No response data")
                    
                    if let statusCode = statusCode, statusCode == 200 {
                        if let token = self.parseAuthToken(from: data) {
                            completion(.success(token))
                        } else {
                            print("Failed to parse token from response.")
                            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Token parsing failed."])))
                        }
                    } else {
                        // Print full response for better context
                        print("Server returned error response: \(response.debugDescription)")
                        completion(.failure(NSError(domain: "", code: statusCode ?? 0, userInfo: [NSLocalizedDescriptionKey: "Registration failed. Check server response."])))
                    }
                case .failure(let error):
                    print("Registration error:", error)
                    completion(.failure(error))
                }
            }


    }

    
    // Helper to parse auth token
    private func parseAuthToken(from data: Data) -> String? {
        do {
            let json = try JSONDecoder().decode([String: String].self, from: data)
            return json["x-access-token"]
        } catch {
            print("Failed to parse token:", error)
            return nil
        }
    }
}
