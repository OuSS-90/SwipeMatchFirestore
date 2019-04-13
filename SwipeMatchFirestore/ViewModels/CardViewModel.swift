//
//  CardViewModel.swift
//  SwipeMatchFirestore
//
//  Created by OuSS on 4/12/19.
//  Copyright © 2019 OuSS. All rights reserved.
//

import UIKit

struct CardViewModel {
    let attributedText: NSAttributedString
    let imagesUrl: [String]
    let textAlignment: NSTextAlignment
    
    init(user: User, textAlignment: NSTextAlignment = .left) {
        let attributedText = NSMutableAttributedString(string: user.name, attributes: [.font : UIFont.systemFont(ofSize: 32, weight: .heavy)])
        attributedText.append(NSAttributedString(string: " \(user.age)", attributes: [.font : UIFont.systemFont(ofSize: 24, weight: .regular)]))
        attributedText.append(NSAttributedString(string: "\n\(user.profession)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        self.attributedText = attributedText
        self.imagesUrl = user.imagesUrl
        self.textAlignment = textAlignment
    }
}
