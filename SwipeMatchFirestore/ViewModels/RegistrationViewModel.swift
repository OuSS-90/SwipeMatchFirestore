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
    
    fileprivate func checkFormValidity() {
        let isFormValid = fullname?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
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
            
            let filename = UUID().uuidString
            let ref = Storage.storage().reference(withPath: "/images/\(filename)")
            guard let data = self.bindableImage.value?.jpegData(compressionQuality: 0.75) else { return }
            ref.putData(data, metadata: nil, completion: { (_, error) in
                if let err = error {
                    completion(.failure(err))
                    return
                }
                
                ref.downloadURL(completion: { (url, error) in
                    if let err = error {
                        completion(.failure(err))
                        return
                    }
                    
                    self.bindableIsRegistering.value = false
                })
            })
        }
    }
}
