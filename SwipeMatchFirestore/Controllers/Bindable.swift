//
//  Bindable.swift
//  SwipeMatchFirestore
//
//  Created by OuSS on 4/14/19.
//  Copyright © 2019 OuSS. All rights reserved.
//

import Foundation

class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?)->())?
    
    func bind(observer: @escaping (T?) ->()) {
        self.observer = observer
    }
    
}
