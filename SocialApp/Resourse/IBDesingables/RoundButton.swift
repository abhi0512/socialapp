//
//  RoundButton.swift
//  stylistlocator
//
//  Created by Abhishek Rathi on 27/02/20.
//  Copyright © 2020 Abhishek Rathi. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class RoundButton: UIButton {

    @IBInspectable var btncornerRadius: CGFloat = 0{
        didSet{
        self.layer.cornerRadius = btncornerRadius
        }
    }

    @IBInspectable var btnborderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth = btnborderWidth
        }
    }

    @IBInspectable var btnborderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = btnborderColor.cgColor
        }
    }
}
