//
//  NotesProtocol.swift
//  WA7_Patil_6279
//
//  Created by Preksha Patil on 28/10/24.
//

import Foundation

protocol NotesProtocol {
    func getAllNotes(completion: @escaping (Result<[Note], Error>) -> Void)
    func addNewNote(text: String, completion: @escaping (Result<Note, Error>) -> Void)
    func deleteNoteByID(noteID: String, completion: @escaping (Result<Void, Error>) -> Void)
}
