//
//  NotesView.swift
//  WA7_Patil_6279
//
//  Created by Preksha Patil on 28/10/24.
//

import UIKit

class NotesView: UIView {
    var tableViewNotes: UITableView!
    var buttonAddNote: UIButton!
    var buttonViewProfile: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupTableView()
        setupButtonAddNote()
        setupButtonViewProfile()
        initConstraints()
    }
    
    private func setupTableView() {
        tableViewNotes = UITableView()
        tableViewNotes.translatesAutoresizingMaskIntoConstraints = false
        tableViewNotes.register(NotesTableViewCell.self, forCellReuseIdentifier: "noteCell")
        addSubview(tableViewNotes)
    }
    
    private func setupButtonAddNote() {
        buttonAddNote = UIButton(type: .system)
        buttonAddNote.setTitle("Add Note", for: .normal)
        buttonAddNote.translatesAutoresizingMaskIntoConstraints = false
        addSubview(buttonAddNote)
    }
    
    private func setupButtonViewProfile() {
        buttonViewProfile = UIButton(type: .system)
        buttonViewProfile.setTitle("View Profile", for: .normal)
        buttonViewProfile.translatesAutoresizingMaskIntoConstraints = false
        addSubview(buttonViewProfile)
    }
    
    
    private func initConstraints() {
        NSLayoutConstraint.activate([
            tableViewNotes.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableViewNotes.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            tableViewNotes.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            tableViewNotes.bottomAnchor.constraint(equalTo: buttonAddNote.topAnchor, constant: -16),
            
            buttonAddNote.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonAddNote.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -120),
            
            buttonViewProfile.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonViewProfile.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -80)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
