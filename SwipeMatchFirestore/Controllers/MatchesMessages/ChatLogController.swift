//
//  ChatLogController.swift
//  SwipeMatchFirestore
//
//  Created by OuSS on 5/31/19.
//  Copyright © 2019 OuSS. All rights reserved.
//

import LBTATools

struct Message {
    let text: String
}

class MessageCell: LBTAListCell<Message> {
    override var item: Message! {
        didSet {
            backgroundColor = .red
        }
    }
}

class ChatLogController: LBTAListController<MessageCell, Message>, UICollectionViewDelegateFlowLayout {
    
    fileprivate lazy var customNavBar = MessagesNavBar(match: self.match)
    
    fileprivate let navBarHeight: CGFloat = 120
    
    fileprivate let match: Match
    
    init(match: Match) {
        self.match = match
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items = [
            .init(text: "Hello from the Tinder Course"),
            .init(text: "Hello from the Tinder Course"),
            .init(text: "Hello from the Tinder Course")
        ]
        
        view.addSubview(customNavBar)
        customNavBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(width: 0, height: navBarHeight))
        
        collectionView.contentInset.top = navBarHeight
        
        customNavBar.backButton.addTarget(self, action: #selector(handleback), for: .touchUpInside)
    }
    
    @objc fileprivate func handleback() {
        navigationController?.popViewController(animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 100)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


