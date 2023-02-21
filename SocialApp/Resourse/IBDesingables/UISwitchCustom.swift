//
//  UISwitchCustom.swift
//  Gypsy
//
//  Created by Abhishek Rathi on 05/11/2020.
//  Copyright © 2020 Abhishek Rathi. All rights reserved.
//

import Foundation
import UIKit
@IBDesignable

class UISwitchCustom: UISwitch {
    @IBInspectable var OffTint: UIColor? {
        didSet {
            self.tintColor = OffTint
            self.layer.cornerRadius = 16
            self.backgroundColor = OffTint
        }
    }
}
