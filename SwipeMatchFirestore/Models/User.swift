//
//  User.swift
//  SwipeMatchFirestore
//
//  Created by OuSS on 4/12/19.
//  Copyright © 2019 OuSS. All rights reserved.
//

import Foundation
import Firebase

struct User {
    var uid: String?
    var name: String?
    var age: Int?
    var profession: String?
    var imageUrl1: String?
    var imageUrl2: String?
    var imageUrl3: String?
    var minSeekingAge: Int?
    var maxSeekingAge: Int?
    
    var dictionary: [String: Any] {
        var dic: [String: Any] = [
            "timestamp": Timestamp(date: Date())
        ]
        
        if let uid = uid {
            dic["uid"] = uid
        }
        
        if let name = name {
            dic["name"] = name
        }
        
        if let profileImageUrl = imageUrl1 {
            dic["profileImageUrl"] = profileImageUrl
        }
        
        return dic
    }
    
    init(dictionary: [String: Any]) {
        // we'll initialize our user here
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String
        self.name = dictionary["fullName"] as? String
        self.imageUrl1 = dictionary["imageUrl1"] as? String
        self.imageUrl2 = dictionary["imageUrl2"] as? String
        self.imageUrl3 = dictionary["imageUrl3"] as? String
        self.uid = dictionary["uid"] as? String
        self.minSeekingAge = dictionary["minSeekingAge"] as? Int
        self.maxSeekingAge = dictionary["maxSeekingAge"] as? Int
    }
}
