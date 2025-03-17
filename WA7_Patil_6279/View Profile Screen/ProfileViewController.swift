//
//  ProfileViewController.swift
//  WA7_Patil_6279
//
//  Created by Preksha Patil on 03/11/24.
//

import UIKit

class ProfileViewController: UIViewController {
    private let profileView = ProfileView()
    var userProfile: UserProfile?

    override func loadView() {
        self.view = profileView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        if let profile = userProfile {
            profileView.configure(with: profile)
        }
        
        profileView.logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
    }

    private func setupNavigationBar() {
        let backButton = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func logoutTapped() {
        // Clear the auth token
        UserDefaults.standard.removeObject(forKey: "authToken")
        navigateToLogin()
    }

    private func navigateToLogin() {
        // Navigate to the login screen
        if let navigationController = navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
}
