//
//  MatchesMessagesController.swift
//  SwipeMatchFirestore
//
//  Created by OuSS on 5/29/19.
//  Copyright © 2019 OuSS. All rights reserved.
//

import LBTATools

class MatchCell: LBTAListCell<UIColor> {
    let profileImageView = UIImageView(image: #imageLiteral(resourceName: "kelly1"), contentMode: .scaleAspectFill)
    let usernameLabel = UILabel(text: "Username Here", font: .systemFont(ofSize: 14, weight: .semibold), textColor: .gray, textAlignment: .center, numberOfLines: 2)
    
    override var item: UIColor! {
        didSet {
            backgroundColor = item
        }
    }
    
    override func setupViews() {
        super.setupViews()
        
        profileImageView.clipsToBounds = true
        profileImageView.constrainWidth(80)
        profileImageView.constrainHeight(80)
        profileImageView.layer.cornerRadius = 80 / 2
        
        stack(profileImageView, usernameLabel, alignment: .center)
    }
}

class MatchesMessagesController: LBTAListController<MatchCell, UIColor>, UICollectionViewDelegateFlowLayout {
    
    let customNavBar = MatchesNavBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        items = [.red, .blue, .green, .purple, .orange]
        
        collectionView.backgroundColor = .white
        collectionView.contentInset.top = 150
        
        view.addSubview(customNavBar)
        customNavBar.anchor(top: view.layoutMarginsGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: 150))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 120, height: 140)
    }
    
}
