//
//  UserService.swift
//  SwipeMatchFirestore
//
//  Created by OuSS on 4/16/19.
//  Copyright © 2019 OuSS. All rights reserved.
//

import Foundation
import Firebase

class UserService {
    
    static let shared = UserService()
    
    func fetchCurrentUser(completion: @escaping (Result<User,Error>) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, error) in
            if let err = error {
                completion(.failure(err))
                return
            }
            
            // fetched our user here
            guard let dictionary = snapshot?.data() else { return }
            let user = User(dictionary: dictionary)
            completion(.success(user))
        }
    }
    
    func saveSwipeToFirestore(didLike: Int, cardUID: String, completion: @escaping (Result<Bool,Error>) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let documentData = [cardUID: didLike]
        
        Firestore.firestore().collection("swipes").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                completion(.failure(err))
                return
            }
            
            if snapshot?.exists == true {
                Firestore.firestore().collection("swipes").document(uid).updateData(documentData) { (err) in
                    if let err = err {
                        print("Failed to save swipe data:", err)
                        return
                    }
                    if didLike == 1 {
                        self.checkIfMatchExists(cardUID: cardUID, completion: completion)
                    }
                }
            } else {
                Firestore.firestore().collection("swipes").document(uid).setData(documentData) { (err) in
                    if let err = err {
                        print("Failed to save swipe data:", err)
                        return
                    }
                    if didLike == 1 {
                        self.checkIfMatchExists(cardUID: cardUID, completion: completion)
                    }
                }
            }
        }
    }
    
    func checkIfMatchExists(cardUID: String, completion: @escaping (Result<Bool,Error>) -> ()) {
        Firestore.firestore().collection("swipes").document(cardUID).getDocument { (snapshot, err) in
            if let err = err {
                completion(.failure(err))
                return
            }
            
            guard let data = snapshot?.data() else { return }
            guard let uid = Auth.auth().currentUser?.uid else { return }
            
            let hasMatched = data[uid] as? Int == 1
            completion(.success(hasMatched))
        }
    }
    
    func saveMatches(uid: String, user: User?) {
        guard let user = user else { return }
        guard let userId = user.uid else { return }
        
        let path = "matches_messages/\(uid)/matches/\(userId)"
        Firestore.firestore().document(path).setData(user.dictionary, completion: { (err) in
            if let err = err {
                print("Failed to save match info:", err)
            }
        })
    }
}
