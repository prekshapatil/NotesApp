//
//  NotesViewController.swift
//  WA7_Patil_6279
//
//  Created by Preksha Patil on 28/10/24.
//

import UIKit
import Alamofire

class NotesViewController: UIViewController {
    private let mainView = NotesView()
    private var notes: [Note] = []
    private var userProfile: UserProfile?
    let defaults = UserDefaults.standard

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        // Hide the back button to prevent showing "Login Screen" or "< Back"
        self.navigationItem.hidesBackButton = true
        
        mainView.tableViewNotes.register(NotesTableViewCell.self, forCellReuseIdentifier: "noteCell")
        mainView.tableViewNotes.dataSource = self
        mainView.tableViewNotes.delegate = self
        mainView.buttonAddNote.addTarget(self, action: #selector(addNoteTapped), for: .touchUpInside)
        mainView.buttonViewProfile.addTarget(self, action: #selector(viewProfileTapped), for: .touchUpInside)
        fetchUserProfile()
        fetchNotes()
    }

    private func setupNavigationBar() {
        self.title = "Notes"
        
        let logoutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
        
        navigationItem.rightBarButtonItems = [logoutButton]
    }
    
    @objc private func viewProfileTapped() {
        let profileVC = ProfileViewController()
        profileVC.userProfile = userProfile
        navigationController?.pushViewController(profileVC, animated: true)
    }

    @objc private func homeButtonTapped() {
        let profileVC = ProfileViewController()
        profileVC.userProfile = userProfile
        navigationController?.pushViewController(profileVC, animated: true)
    }

    @objc private func logoutTapped() {
        // Clear the auth token
        UserDefaults.standard.removeObject(forKey: "authToken")
        //defaults.removeObject(forKey: "authToken")
        navigateToLogin()
    }

    private func navigateToLogin() {
        // Navigate to the login screen
        navigationController?.popToRootViewController(animated: true)
    }

    @objc private func backToLogin() {
        navigationController?.popViewController(animated: true)
    }

    private func fetchUserProfile() {
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        
        AF.request("http://apis.sakibnm.work:3000/api/auth/me", headers: ["x-access-token": token])
            .responseDecodable(of: UserProfile.self) { response in
                switch response.result {
                case .success(let profile):
                    self.userProfile = profile
                case .failure(let error):
                    print("Failed to fetch user profile: \(error)")
                }
            }
    }

    private func fetchNotes() {
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        
        AF.request("http://apis.sakibnm.work:3000/api/note/getall", headers: ["x-access-token": token])
            .responseDecodable(of: NotesResponse.self) { response in
                switch response.result {
                case .success(let data):
                    self.notes = data.notes
                    self.mainView.tableViewNotes.reloadData()
                case .failure(let error):
                    print("Failed to fetch notes: \(error)")
                }
            }
    }

    private func addNewNote(text: String) {
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        
        AF.request("http://apis.sakibnm.work:3000/api/note/post", method: .post, parameters: ["text": text], headers: ["x-access-token": token])
            .response { response in
                switch response.result {
                case .success:
                    self.fetchNotes()
                case .failure(let error):
                    print("Failed to add note: \(error)")
                }
            }
    }

    private func deleteNoteAt(index: Int) {
        let noteId = notes[index].id
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        
        AF.request("http://apis.sakibnm.work:3000/api/note/delete", method: .post, parameters: ["id": noteId], encoding: URLEncoding.default, headers: ["x-access-token": token])
            .response { response in
                switch response.result {
                case .success:
                    self.notes.remove(at: index)
                    self.mainView.tableViewNotes.reloadData()
                case .failure(let error):
                    print("Failed to delete note: \(error)")
                }
            }
    }

    @objc private func addNoteTapped() {
        let alert = UIAlertController(title: "Add New Note", message: "Enter your note below", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Note"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] _ in
            guard let self = self, let noteText = alert.textFields?.first?.text, !noteText.isEmpty else { return }
            self.addNewNote(text: noteText)
        }))
        
        present(alert, animated: true, completion: nil)
    }
}

extension NotesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell", for: indexPath) as? NotesTableViewCell else {
            return UITableViewCell()
        }
        cell.labelNote.text = notes[indexPath.row].text
        
        // Set up delete action closure
        cell.deleteAction = { [weak self] in
            guard let self = self else { return }
            self.confirmDelete(noteIndex: indexPath.row)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let note = notes[indexPath.row]
            showNotePopup(note.text)
        }
    
    private func showNotePopup(_ text: String) {
            let alert = UIAlertController(title: "Note", message: nil, preferredStyle: .alert)
            
            let textView = UITextView()
            textView.isEditable = false
            textView.text = text
            textView.translatesAutoresizingMaskIntoConstraints = false
            textView.heightAnchor.constraint(equalToConstant: 150).isActive = true
            
            alert.view.addSubview(textView)
            
            NSLayoutConstraint.activate([
                textView.leadingAnchor.constraint(equalTo: alert.view.leadingAnchor, constant: 8),
                textView.trailingAnchor.constraint(equalTo: alert.view.trailingAnchor, constant: -8),
                textView.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 50),
                textView.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: -45)
            ])
            
            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
            
            present(alert, animated: true, completion: nil)
        }

    private func confirmDelete(noteIndex: Int) {
        let alert = UIAlertController(title: "Delete Note", message: "Are you sure you want to delete this note?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.deleteNoteAt(index: noteIndex)
        }
        alert.addAction(deleteAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
}
