//
//  NotesAPICalls.swift
//  WA7_Patil_6279
//
//  Created by Preksha Patil on 28/10/24.
//

import Foundation
import Alamofire

class NotesAPICalls: NotesProtocol {
    
    // Fetch all notes
    func getAllNotes(completion: @escaping (Result<[Note], Error>) -> Void) {
        let url = APIConfigs.notesBaseURL + "getall"
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        
        let headers: HTTPHeaders = [
            "x-access-token": token
        ]
        
        AF.request(url, method: .get, headers: headers)
            .responseDecodable(of: [Note].self) { response in
                switch response.result {
                case .success(let notes):
                    completion(.success(notes))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    // Add a new note
    func addNewNote(text: String, completion: @escaping (Result<Note, Error>) -> Void) {
        let url = APIConfigs.notesBaseURL + "post"
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        
        let headers: HTTPHeaders = [
            "x-access-token": token
        ]
        
        let parameters: [String: Any] = [
            "text": text
        ]
        
        AF.request(url, method: .post, parameters: parameters, headers: headers)
            .responseDecodable(of: Note.self) { response in
                switch response.result {
                case .success(let note):
                    completion(.success(note))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    // Delete a note by ID
    func deleteNoteByID(noteID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = APIConfigs.notesBaseURL + "delete"
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        
        let headers: HTTPHeaders = [
            "x-access-token": token
        ]
        
        let parameters: [String: Any] = [
            "id": noteID
        ]
        
        AF.request(url, method: .post, parameters: parameters, headers: headers)
            .response { response in
                switch response.result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}
