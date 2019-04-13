//
//  CardViewModel.swift
//  SwipeMatchFirestore
//
//  Created by OuSS on 4/12/19.
//  Copyright © 2019 OuSS. All rights reserved.
//

import UIKit

class CardViewModel {
    let attributedText: NSAttributedString
    let imagesUrl: [String]
    let textAlignment: NSTextAlignment
    
    fileprivate var imageIndex = 0 {
        didSet{
            let imageUrl = imagesUrl[imageIndex]
            let image = UIImage(named: imageUrl)
            imageIndexObserver?(imageIndex, image)
        }
    }
    
    var imageIndexObserver: ((Int, UIImage?) -> ())?
    
    init(user: User, textAlignment: NSTextAlignment = .left) {
        let attributedText = NSMutableAttributedString(string: user.name, attributes: [.font : UIFont.systemFont(ofSize: 32, weight: .heavy)])
        attributedText.append(NSAttributedString(string: " \(user.age)", attributes: [.font : UIFont.systemFont(ofSize: 24, weight: .regular)]))
        attributedText.append(NSAttributedString(string: "\n\(user.profession)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        self.attributedText = attributedText
        self.imagesUrl = user.imagesUrl
        self.textAlignment = textAlignment
    }
    
    func advanceToNextPhoto() {
        imageIndex = min(imageIndex + 1, imagesUrl.count - 1)
    }
    
    func backToPreviousPhoto() {
        imageIndex = max(0, imageIndex - 1)
    }
}
