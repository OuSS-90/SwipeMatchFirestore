//
//  ViewController.swift
//  SwipeMatchFirestore
//
//  Created by OuSS on 4/11/19.
//  Copyright © 2019 OuSS. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomStackView = HomeBottomStackView()
    
    let users = [
        User(name: "Kelly", age: 23, profession: "Music DJ", imagesUrl: ["kelly1" ,"kelly2", "kelly3"]),
        User(name: "Jane", age: 18, profession: "Teacher", imagesUrl: ["jane1" ,"jane2", "jane3"])
    ]
    
    var cardViewModels = [CardViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupLayout()
        setupCardView()
    }
    
    // MARK:- fileprivate
    
    fileprivate func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomStackView])
        stackView.axis = .vertical
        
        view.addSubview(stackView)
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        stackView.bringSubviewToFront(cardsDeckView)
    }
    
    fileprivate func setupCardView() {
        cardViewModels = users.map{CardViewModel(user: $0)}
        cardViewModels.forEach { (cardViewModel) in
            let cardView = CardView()
            cardView.cardViewModel = cardViewModel
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
}

