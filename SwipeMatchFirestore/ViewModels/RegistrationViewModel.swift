//
//  RegistrationViewModel.swift
//  SwipeMatchFirestore
//
//  Created by OuSS on 4/14/19.
//  Copyright © 2019 OuSS. All rights reserved.
//

import UIKit

class RegistrationViewModel {
    var bindableImage = Bindable<UIImage>()
    var bindableIsFormValid = Bindable<Bool>()
    
    var fullname: String? { didSet { checkFormValidity() } }
    var email: String? { didSet { checkFormValidity() } }
    var password: String? { didSet { checkFormValidity() } }
    
    fileprivate func checkFormValidity() {
        let isFormValid = fullname?.isEmpty == false && email?.isEmpty == false && password?.isEmpty == false
        bindableIsFormValid.value = isFormValid
    }
}
