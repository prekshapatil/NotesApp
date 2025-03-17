//
//  RegisterViewController.swift
//  WA7_Patil_6279
//
//  Created by Preksha Patil on 28/10/24.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController {
    private let registerView = RegisterView()

    override func loadView() {
        self.view = registerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = ""
        setupActions()
    }

    private func setupActions() {
        registerView.registerButton.addTarget(self, action: #selector(register), for: .touchUpInside)
    }

    @objc func register() {
        guard let name = registerView.nameTextField.text, !name.isEmpty,
              let email = registerView.emailTextField.text, !email.isEmpty,
              let password = registerView.passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Please fill in all fields.")
            return
        }
        
        // Email validation
        if !isValidEmail(email) {
            showAlert(message: "Please enter a valid email.")
            return
        }

        let parameters: [String: String] = ["name": name, "email": email, "password": password]

        AF.request("http://apis.sakibnm.work:3000/api/auth/register",
                   method: .post,
                   parameters: parameters,
                   encoding: URLEncoding.default)
            .response { response in
                switch response.result {
                case .success(let data):
                    if let data = data, let responseText = String(data: data, encoding: .utf8) {
                        print("Raw response data: \(responseText)")

                        // Check for known plain text error responses
                        if responseText.contains("User already exists") {
                            self.showAlert(message: "User already exists.")
                            return
                        } else if responseText.contains("There was a problem registering the user") {
                            self.showAlert(message: "User already exists.")
                            return
                        }

                        // Attempt to parse as JSON if no known plain text error was found
                        do {
                            if let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                               let auth = jsonDict["auth"] as? Bool, auth {
                                // Successfully registered
                                if let token = jsonDict["token"] as? String {
                                    UserDefaults.standard.set(token, forKey: "authToken")
                                    self.navigateToMainScreen()
                                }
                            } else {
                                self.showAlert(message: "Registration failed. Please try again.")
                            }
                        } catch {
                            print("Error parsing JSON: \(error)")
                            self.showAlert(message: "Failed to parse response.")
                        }
                    }
                case .failure(let error):
                    print("Registration failed: \(error)")
                    self.showAlert(message: "Registration failed. Please try again.")
                }
            }
    }




    private func navigateToMainScreen() {
        let mainVC = NotesViewController()
        navigationController?.pushViewController(mainVC, animated: true)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
