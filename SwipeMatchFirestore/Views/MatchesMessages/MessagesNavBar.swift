//
//  MessagesNavBar.swift
//  SwipeMatchFirestore
//
//  Created by OuSS on 5/31/19.
//  Copyright © 2019 OuSS. All rights reserved.
//

import LBTATools

class MessagesNavBar: UIView {
    
    let userProfileImageView = CircularImageView(width: 44, image: #imageLiteral(resourceName: "jane1.jpg"))
    let nameLabel = UILabel(text: "USERNAME", font: .systemFont(ofSize: 16))
    
    let backButton = UIButton(image: #imageLiteral(resourceName: "back"), tintColor: #colorLiteral(red: 0.9792197347, green: 0.2754820287, blue: 0.3579338193, alpha: 1))
    let flagButton = UIButton(image: #imageLiteral(resourceName: "flag"), tintColor: #colorLiteral(red: 0.9792197347, green: 0.2754820287, blue: 0.3579338193, alpha: 1))
    
    fileprivate let match: Match
    
    init(match: Match) {
        self.match = match
        
        nameLabel.text = match.name
        userProfileImageView.sd_setImage(with: URL(string: match.profileImageUrl))
        
        super.init(frame: .zero)
        backgroundColor = .white
        
        setupShadow(opacity: 0.2, radius: 8, offset: .init(width: 0, height: 10), color: .init(white: 0, alpha: 0.3))
        
        let middleStack =
            stack(
                userProfileImageView,
                nameLabel,
                spacing: 8,
                alignment: .center)
        
        hstack(backButton,
               middleStack,
               flagButton,
               alignment: .center).withMargins(.init(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
}

