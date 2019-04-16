//
//  SettingsController.swift
//  SwipeMatchFirestore
//
//  Created by OuSS on 4/15/19.
//  Copyright © 2019 OuSS. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import JGProgressHUD

class CustomImagePickerController: UIImagePickerController {
    var imageButton: UIButton?
}

class SettingsController: UITableViewController {
    
    let titles = ["Name", "Profession", "Age", "Bio"]
    
    // instance properties
    lazy var image1Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image2Button = createButton(selector: #selector(handleSelectPhoto))
    lazy var image3Button = createButton(selector: #selector(handleSelectPhoto))
    
    @objc func handleSelectPhoto(button: UIButton) {
        let imagePicker = CustomImagePickerController()
        imagePicker.delegate = self
        imagePicker.imageButton = button
        present(imagePicker, animated: true)
    }
    
    func createButton(selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        return button
    }
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationItems()
        tableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        tableView.tableFooterView = UIView()
        fetchUsersFromFirestore()
    }
    
    fileprivate func fetchUsersFromFirestore() {
        guard let id = Auth.auth().currentUser?.uid else { return }
        Firestore.firestore().collection("users").document(id).getDocument { (snapshot, error) in
            if let err = error {
                print(err)
                return
            }
            
            
            guard let id = snapshot?.documentID else { return }
            guard let dic = snapshot?.data() else { return }
            self.user = User(dictionary: dic, id: id)
            self.loadUserPhotos()
            self.tableView.reloadData()
        }
    }
    
    fileprivate func loadUserPhotos() {
        guard let imageUrl = user?.imagesUrl?.first, let url = URL(string: imageUrl) else { return }
        SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
            self.image1Button.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
    }
    
    lazy var header: UIView = {
        let view = UIView()
        view.addSubview(image1Button)
        let padding: CGFloat = 16
        image1Button.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: nil, padding: .init(top: padding, left: padding, bottom: padding, right: 0))
        image1Button.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.45).isActive = true
        
        let stackView = UIStackView(arrangedSubviews: [image2Button, image3Button])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = padding
        
        view.addSubview(stackView)
        stackView.anchor(top: view.topAnchor, leading: image1Button.trailingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(top: padding, left: padding, bottom: padding, right: padding))
        return view
    }()
    
    class HeaderLabel: UILabel {
        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.insetBy(dx: 16, dy: 0))
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return section == 0 ? header : nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 300 : 40
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return titles.count + 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? nil : titles[section - 1]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SettingsCell(style: .default, reuseIdentifier: nil)
        cell.textField.placeholder = "Enter \(titles[indexPath.section - 1])"
        switch indexPath.section {
        case 1:
            cell.textField.text = user?.name
            cell.textField.addTarget(self, action: #selector(handleNameChange), for: .editingChanged)
        case 2:
            cell.textField.text = user?.profession
            cell.textField.addTarget(self, action: #selector(handleProfessionChange), for: .editingChanged)
        case 3:
            cell.textField.addTarget(self, action: #selector(handleAgeChange), for: .editingChanged)
            if let age = user?.age {
                cell.textField.text = String(age)
            }
        default:
            cell.textField.placeholder = "Enter Bio"
        }
        return cell
    }
    
    @objc fileprivate func handleNameChange(textField: UITextField) {
        self.user?.name = textField.text
    }
    
    @objc fileprivate func handleProfessionChange(textField: UITextField) {
        self.user?.profession = textField.text
    }
    
    @objc fileprivate func handleAgeChange(textField: UITextField) {
        self.user?.age = Int(textField.text ?? "")
    }
    
    fileprivate func setupNavigationItems() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave)),
            UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleCancel))
        ]
    }
    
    @objc fileprivate func handleSave() {
        print("Saving our settings data into Firestore")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let docData: [String: Any] = [
            "uid": uid,
            "fullName": user?.name ?? "",
            "imageUrl1": user?.imagesUrl?.first ?? "",
            "age": user?.age ?? -1,
            "profession": user?.profession ?? ""
        ]
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving settings"
        hud.show(in: view)
        Firestore.firestore().collection("users").document(uid).setData(docData) { (err) in
            hud.dismiss()
            if let err = err {
                print("Failed to save user settings:", err)
                return
            }
            
            print("Finished saving user info")
        }
    }
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true)
    }
    
}

extension SettingsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        let imageButton = (picker as? CustomImagePickerController)?.imageButton
        imageButton?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true)
    }
}
