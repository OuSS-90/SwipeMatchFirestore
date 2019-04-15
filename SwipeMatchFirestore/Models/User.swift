//
//  User.swift
//  SwipeMatchFirestore
//
//  Created by OuSS on 4/12/19.
//  Copyright © 2019 OuSS. All rights reserved.
//

import Foundation

struct User {
    var id: String?
    var name: String?
    var age: Int?
    var profession: String?
    var imagesUrl: [String]?
    
    init(dictionary: [String: Any], id: String? = nil) {
        // we'll initialize our user here
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String
        self.name = dictionary["fullName"] as? String
        if let imageUrl1 = dictionary["imageUrl1"] as? String {
            self.imagesUrl = [imageUrl1]
        }
        
        self.id = id
    }
}
