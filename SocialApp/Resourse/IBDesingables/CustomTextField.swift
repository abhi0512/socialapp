//
//  CustomTextField.swift
//  aua
//
//  Created by Abhishek Rathi on 16/11/19.
//  Copyright © 2019 Abhishek Rathi. All rights reserved.
//

import Foundation
import UIKit

    @IBDesignable
    class CustomTextField: UITextField {
        
        var padding: UIEdgeInsets {
            get {
                return UIEdgeInsets(top: 0, left: paddingValue, bottom: 0, right: paddingValue)
            }
        }
        
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: padding)

        }
        
        override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: padding)

        }
        
        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.inset(by: padding)
        }
        
        @IBInspectable var paddingValue: CGFloat = 0
        
        
        @IBInspectable var txtborderColor: UIColor? = UIColor.clear {
            didSet {
             
                layer.borderColor = self.txtborderColor?.cgColor
            }
        }
        
        @IBInspectable var txtborderWidth: CGFloat = 0 {
            didSet {
                layer.borderWidth = self.txtborderWidth
            }
        }
        
        @IBInspectable var txtcornerRadius: CGFloat = 0 {
            didSet {
                layer.cornerRadius = self.txtcornerRadius
                layer.masksToBounds = self.txtcornerRadius > 0
            }
        }
        
        
        
        @IBInspectable var txtplaceHolderColor: UIColor? {
               get {
                   return self.txtplaceHolderColor
               }
               set {
                   self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
               }
           }
        
        @IBInspectable var rightImage : NSString = "" {
            didSet{
//                self.rightView = UIImageView(image: rightImage)
//                // select mode -> .never .whileEditing .unlessEditing .always
//                self.rightViewMode = .always
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                let image = UIImage(named:self.rightImage as String)
                imageView.image = image
                self.rightView = imageView
                self.rightViewMode = .whileEditing
                
            }
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
        }
        
        override func draw(_ rect: CGRect) {
            self.layer.cornerRadius = self.txtcornerRadius
            self.layer.borderWidth = self.txtborderWidth
            self.layer.borderColor = self.txtborderColor?.cgColor
        }
}

