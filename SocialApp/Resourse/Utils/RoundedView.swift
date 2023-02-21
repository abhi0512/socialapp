//
//  RoundedView.swift
//  iOS Equaleyes Foundation
//
//  Created by Dejan Skledar on 23/10/2017.
//  Copyright © 2017 Equaleyes Solutions Ltd. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedView: UIView, Roundable {
    @IBInspectable var isCircle: Bool = false {
        didSet {
            setupLayer()
        }
    }

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            setupLayer()
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            setupLayer()
        }
    }

    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            setupLayer()
        }
    }
    
    // Shadow color
    @IBInspectable var shadowColor: UIColor {
        get {
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set {
            self.layer.shadowColor = newValue.cgColor
        }
    }
    
    // Shadow offsets
    @IBInspectable var shadowOffset: CGSize {
        get {
            return self.layer.shadowOffset
        }
        set {
            self.layer.shadowOffset = newValue
        }
    }
    
    // Shadow opacity
    @IBInspectable var shadowOpacity: Float {
        get {
            return self.layer.shadowOpacity
        }
        set {
            self.layer.shadowOpacity = newValue
        }
    }
    
    // Shadow radius
    @IBInspectable var shadowRadius: CGFloat {
        get {
            return self.layer.shadowRadius
        }
        set {
            self.layer.shadowRadius = newValue
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupLayer()
    }
}
