//
//  BorderTextView.swift
//  aua
//
//  Created by Abhishek Rathi on 02/12/19.
//  Copyright © 2019 Abhishek Rathi. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class BorderTextView: UITextView {

   var red = UIColor(red: 100.0/255.0, green: 130.0/255.0, blue: 230.0/255.0, alpha: 1.0)

    @IBInspectable var borderColor: UIColor? = UIColor.clear {
        didSet {
            layer.borderColor = self.borderColor?.cgColor
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = 2
        }
        get {
            return layer.borderWidth
        }
    }

    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = 10.0
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
}
