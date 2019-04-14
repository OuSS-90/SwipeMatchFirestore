//
//  RegistrationViewModel.swift
//  SwipeMatchFirestore
//
//  Created by OuSS on 4/14/19.
//  Copyright © 2019 OuSS. All rights reserved.
//

import Foundation

class RegistrationViewModel {
    var fullname: String? { didSet { checkFormValidity() } }
    var email: String? { didSet { checkFormValidity() } }
    var password: String? { didSet { checkFormValidity() } }
    
    var isFormValidObserver: ((Bool) -> ())?
    
    fileprivate func checkFormValidity() {
        let isFormValid = fullname?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        isFormValidObserver?(isFormValid)
    }
}
