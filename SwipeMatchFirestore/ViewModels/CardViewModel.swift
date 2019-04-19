//
//  CardViewModel.swift
//  SwipeMatchFirestore
//
//  Created by OuSS on 4/12/19.
//  Copyright © 2019 OuSS. All rights reserved.
//

import UIKit

class CardViewModel {
    let uid: String?
    let attributedText: NSAttributedString
    let imageUrls: [String]
    let textAlignment: NSTextAlignment
    
    init(user: User, textAlignment: NSTextAlignment = .left) {
        self.uid = user.uid
        let attributedText = NSMutableAttributedString(string: user.name ?? "", attributes: [.font : UIFont.systemFont(ofSize: 32, weight: .heavy)])
        let ageString = user.age != nil ? "\(user.age!)" : "N\\A"
        attributedText.append(NSAttributedString(string: " \(ageString)", attributes: [.font : UIFont.systemFont(ofSize: 24, weight: .regular)]))
        let professionString = user.profession != nil ? user.profession! : "Not available"
        attributedText.append(NSAttributedString(string: "\n\(professionString)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        self.attributedText = attributedText
        
        var imageUrls = [String]() // empty string array
        if let url = user.imageUrl1 { imageUrls.append(url) }
        if let url = user.imageUrl2 { imageUrls.append(url) }
        if let url = user.imageUrl3 { imageUrls.append(url) }
        
        self.imageUrls = imageUrls
        self.textAlignment = textAlignment
    }
}
