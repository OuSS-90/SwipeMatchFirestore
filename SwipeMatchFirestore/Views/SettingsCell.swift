//
//  SettingsCell.swift
//  SwipeMatchFirestore
//
//  Created by OuSS on 4/15/19.
//  Copyright © 2019 OuSS. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    let textField: CustomTextField = {
        let tf = CustomTextField(padding: 24, height: 44)
        tf.placeholder = "Enter Name"
        return tf
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(textField)
        textField.fillSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
}

