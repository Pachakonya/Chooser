//
//  FirebaseManager.swift
//  Chooser
//
//  Created by Dastan Sugirbay on 28.04.2025.
//

import FirebaseFirestore

enum WinnerSetStatus {
    case success
    case failed(error: Error)
}

enum WinnerGetStatus {
    case success(winner: Int)
    case failed(error: Error?)
}

class FirebaseManager {
    static let shared = FirebaseManager()
    private let db = Firestore.firestore()

    private init() {}

    func setWinner(winnerNumber: Int, completion: @escaping (WinnerSetStatus) -> ()) {
        db.collection("games").document("game1").setData([
            "winner": winnerNumber
        ]) { error in
            if let error = error {
                completion(.failed(error: error))
            } else {
                completion(.success)
            }
        }
    }
    
    func getWinner(completion: @escaping (WinnerGetStatus) -> ()) {
        db.collection("games").document("game1").getDocument { (document, error) in
            print("!!! completed")
            if let document = document, document.exists {
                let data = document.data()
                let winner = data?["winner"] as? Int ?? 1
                completion(.success(winner: winner))
            } else {
                completion(.failed(error: error))
            }
        }
    }
    
    func getTasks(completion: @escaping ([String]) -> ()) {
        db.collection("tasks").getDocuments { (snapshot, error) in
            
            if let _ = error {
                completion(ConstantValues.tasks)
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(ConstantValues.tasks)
                return
            }
            
            for document in documents {
                let data = document.data()
                
                if let dbTasks = data["tasks"] as? [String] {
                    completion(dbTasks)
                } else {
                    completion(ConstantValues.tasks)
                }
            }
        }
    }
    
    
}
