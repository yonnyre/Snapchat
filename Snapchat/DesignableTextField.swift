//
//  DesignableTextField.swift
//  Snapchat
//
//  Created by yonny on 1/07/18.
//  Copyright © 2018 Yonnyr Team. All rights reserved.
//

import UIKit
@IBDesignable
class DesignableTextField: UITextField {

    @IBInspectable var leftImage: UIImage? {
        didSet{
            updateView();
        }
    }
    func updateView(){
        if let image = leftImage{
            leftViewMode = .always
            
            let imageView = UIImageView(frame: CGRect(x: 15, y: 0, width: 20, height: 20))
            imageView.image = image
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 25, height: 20))
            view.addSubview(imageView)
            leftView = imageView
        }else{
            leftViewMode = .never
        }
    }
}
