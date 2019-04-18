//
//  RegistrationViewModel.swift
//  SwipeMatchFirestore
//
//  Created by OuSS on 4/14/19.
//  Copyright © 2019 OuSS. All rights reserved.
//

import UIKit
import Firebase

class RegistrationViewModel {
    var bindableIsRegistering = Bindable<Bool>()
    var bindableImage = Bindable<UIImage>()
    var bindableIsFormValid = Bindable<Bool>()
    
    var fullname: String? { didSet { checkFormValidity() } }
    var email: String? { didSet { checkFormValidity() } }
    var password: String? { didSet { checkFormValidity() } }
    
    func checkFormValidity() {
        let isFormValid = fullname?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false && bindableImage.value != nil
        bindableIsFormValid.value = isFormValid
    }
    
    func performRegistration(completion: @escaping (Result<Bool,Error>) -> ()) {
        guard let email = email else { return }
        guard let password = password else { return }
        
        bindableIsRegistering.value = true
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let err = error {
                completion(.failure(err))
                return
            }
            
            self.saveImageToFirebase(completion: completion)
        }
    }
    
    fileprivate func saveImageToFirebase(completion: @escaping (Result<Bool,Error>) -> ()) {
        guard let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) else { return }
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let filename = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(filename)")
        
        ref.putData(imageData, metadata: metadata, completion: { (_, error) in
            
            if let err = error {
                completion(.failure(err))
                return
            }
            
            print("Finished uploading image to storage")
            ref.downloadURL(completion: { (url, error) in
                if let err = error {
                    completion(.failure(err))
                    return
                }
                
                self.bindableIsRegistering.value = false
                
                let imageUrl = url?.absoluteString ?? ""
                self.saveInfoToFirestore(imageUrl: imageUrl, completion: completion)
            })
            
        })
    }
    
    fileprivate func saveInfoToFirestore(imageUrl: String, completion: @escaping (Result<Bool,Error>) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let docData: [String : Any] = [
            "fullName": fullname ?? "",
            "uid": uid,
            "imageUrl1": imageUrl,
            "age": DEFAULT_AGE,
            "minSeekingAge": MIN_SEEKING_AGE,
            "maxSeekingAge": MAX_SEEKING_AGE
        ]
        
        Firestore.firestore().collection("users").document(uid).setData(docData) { (error) in
            if let err = error {
                completion(.failure(err))
                return
            }
            
            completion(.success(true))
        }
    }
    
}
