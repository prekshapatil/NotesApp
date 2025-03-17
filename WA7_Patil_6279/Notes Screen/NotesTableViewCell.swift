//
//  NotesTableViewCell.swift
//  WA7_Patil_6279
//
//  Created by Preksha Patil on 28/10/24.
//

import UIKit

class NotesTableViewCell: UITableViewCell {
    var labelNote: UILabel!
    var deleteAction: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLabelNote()
        setupDeleteButton()
        initConstraints()
    }

    private func setupLabelNote() {
        labelNote = UILabel()
        labelNote.font = UIFont.systemFont(ofSize: 16)
        labelNote.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelNote)
    }

    private func setupDeleteButton() {
        let deleteButton = UIButton(type: .system)
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.showsMenuAsPrimaryAction = true

        // Add the delete menu to the button
        deleteButton.menu = UIMenu(title: "", children: [
            UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
                self?.deleteAction?()
            }
        ])

        accessoryView = deleteButton
    }

    private func initConstraints() {
        NSLayoutConstraint.activate([
            labelNote.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            labelNote.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            labelNote.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),  // Leave space for delete button
            labelNote.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
