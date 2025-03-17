//
//  AuthProtocol.swift
//  WA7_Patil_6279
//
//  Created by Preksha Patil on 28/10/24.
//

import Foundation

protocol AuthProtocol {
    func login(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void)
    func register(name: String, email: String, password: String, completion: @escaping (Result<String, Error>) -> Void)
    func logout()
}

