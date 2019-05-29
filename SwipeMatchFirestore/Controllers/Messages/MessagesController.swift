//
//  MessagesController.swift
//  SwipeMatchFirestore
//
//  Created by OuSS on 5/29/19.
//  Copyright © 2019 OuSS. All rights reserved.
//

import UIKit
import LBTATools

class MessagesController: UICollectionViewController {
    
    let navBar: UIView = {
        let view = UIView(backgroundColor: .white)
        let imageView = UIImageView(image: #imageLiteral(resourceName: "top_right_messages").withRenderingMode(.alwaysTemplate), contentMode: .scaleAspectFit)
        imageView.tintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        let messagesLabel = UILabel(text: "Messages", font: .boldSystemFont(ofSize: 20), textColor: #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1), textAlignment: .center)
        let feedLabel = UILabel(text: "Feed", font: .boldSystemFont(ofSize: 20), textColor: .gray, textAlignment: .center)
        view.stack(imageView.withHeight(44), view.hstack(messagesLabel, feedLabel, distribution: .fillEqually)).padTop(10)
        view.setupShadow(opacity: 0.2, radius: 8, offset: .init(width: 0, height: 10), color: .init(white: 0, alpha: 0.3))
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        view.addSubview(navBar)
        navBar.anchor(top: view.layoutMarginsGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 150))
    }
    
}
