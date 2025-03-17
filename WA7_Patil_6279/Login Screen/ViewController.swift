//
//  ViewController.swift
//  WA7_Patil_6279
//
//  Created by Preksha Patil on 28/10/24.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    private let loginView = LoginView()
    let defaults = UserDefaults.standard

    override func loadView() {
        self.view = loginView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = ""
        setupActions()
        
        // Check if token exists
        checkIfUserIsAlreadyLoggedIn()
    }

    private func setupActions() {
        loginView.loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
        loginView.registerButton.addTarget(self, action: #selector(navigateToRegister), for: .touchUpInside)
    }

    
    @objc private func login() {
        guard let email = loginView.emailTextField.text, !email.isEmpty,
              let password = loginView.passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Please fill in all fields.")
            return
        }

        // Email validation
        if !isValidEmail(email) {
            showAlert(message: "Please enter a valid email.")
            return
        }

        let parameters: [String: String] = ["email": email, "password": password]

        AF.request("http://apis.sakibnm.work:3000/api/auth/login", method: .post, parameters: parameters)
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    if let json = data as? [String: Any], let auth = json["auth"] as? Bool, auth {
                        if let token = json["token"] as? String {
                            UserDefaults.standard.set(token, forKey: "authToken")
                            self.navigateToMainScreen()
                        }
                    } else {
                        self.showAlert(message: "User not found or incorrect password.")
                    }
                case .failure(let error):
                    print("Login failed: \(error)")
                    self.showAlert(message: "Login failed. Please check your credentials.")
                }
            }
    }

    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    @objc private func navigateToRegister() {
        let registerVC = RegisterViewController()

           // Set the back button title for the next screen
           let backButtonItem = UIBarButtonItem()
           backButtonItem.title = "Back"
           navigationItem.backBarButtonItem = backButtonItem

           navigationController?.pushViewController(registerVC, animated: true)
    }
    
    private func checkIfUserIsAlreadyLoggedIn() {
        if let _ = defaults.string(forKey: "authToken") {
            navigateToMainScreen()
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
}

