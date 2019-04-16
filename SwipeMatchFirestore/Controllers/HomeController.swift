//
//  ViewController.swift
//  SwipeMatchFirestore
//
//  Created by OuSS on 4/11/19.
//  Copyright © 2019 OuSS. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class HomeController: UIViewController {
    
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    let bottomControls = HomeBottomStackView()
    
    var cardViewModels = [CardViewModel]()
    var lastDocument : DocumentSnapshot?
    fileprivate var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        bottomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        
        setupLayout()
        fetchCurrentUser()
    }
    
    // MARK:- fileprivate
    
    @objc func handleSettings() {
        let settingsController = SettingsController()
        settingsController.delegate = self
        let navController = UINavigationController(rootViewController: settingsController)
        present(navController, animated: true)
    }
    
    @objc fileprivate func handleRefresh() {
        fetchNextUsers()
    }
    
    fileprivate func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, bottomControls])
        stackView.axis = .vertical
        
        view.addSubview(stackView)
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        stackView.bringSubviewToFront(cardsDeckView)
    }
    
    fileprivate func fetchCurrentUser() {
        UserService.shared.fetchCurrentUser { (result) in
            switch result {
            case .success(let user):
                self.user = user
                self.fetchUsersFromFirestore()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    fileprivate func fetchUsersFromFirestore() {
        guard let minAge = user?.minSeekingAge, let maxAge = user?.maxSeekingAge else { return }
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fetching Users"
        hud.show(in: view)
        
        //Firestore.firestore().collection("users").limit(to: 2).getDocuments { (snapshot, error) in
        Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge).getDocuments { (snapshot, error) in
            hud.dismiss()
            if let err = error {
                print("Failed to fetch users:", err)
                return
            }
            
            snapshot?.documents.forEach({ (document) in
                self.setupCardView(document: document)
            })
        }
    }
    
    fileprivate func fetchNextUsers() {
        guard let lastDocument = lastDocument else { return }
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fetching Users"
        hud.show(in: view)
        
        Firestore.firestore().collection("users").start(afterDocument: lastDocument).limit(to: 2).getDocuments { (snapshot, error) in
            
            hud.dismiss()
            
            if let err = error {
                print("Failed to fetch users:", err)
                return
            }
            
            snapshot?.documents.forEach({ (document) in
                self.setupCardView(document: document)
            })
        }
    }
    
    fileprivate func setupCardView(document: QueryDocumentSnapshot) {
        let userDictionary = document.data()
        let user = User(dictionary: userDictionary)
        let cardViewModel = CardViewModel(user: user)
        let cardView = CardView()
        cardView.cardViewModel = cardViewModel
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
        lastDocument = document
    }
}

extension HomeController: SettingsControllerDelegate {
    func didSaveSettings() {
        fetchCurrentUser()
    }
}

