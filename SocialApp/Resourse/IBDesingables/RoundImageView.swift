//
//  RoundImageView.swift
//  RoadRez
//
//  Created by Abhishek Rathi on 27/06/19.
//  Copyright © 2019 Abhishek Rathi. All rights reserved.
//

import UIKit

@IBDesignable class RoundImageView: UIImageView {
    private var _round = false
    private var _borderColor = UIColor.clear
    private var _borderWidth: CGFloat = 0
    
    @IBInspectable var round: Bool {
        set {
            _round = newValue
            makeRound()
        }
        get {
            return self._round
        }
    }
    
    @IBInspectable  var imgborderColor: UIColor {
        set {
            _borderColor = newValue
            setBorderColor()
        }
        get {
            return self._borderColor
        }
    }
    
    @IBInspectable var imgborderWidth: CGFloat {
        set {
            _borderWidth = newValue
            setBorderWidth()
        }
        get {
            return self._borderWidth
        }
    }
    
    override internal var frame: CGRect {
        set {
            super.frame = newValue
            makeRound()
        }
        get {
            return super.frame
        }
    }
    
    private func makeRound() {
        if self.round {
            self.clipsToBounds = true
            self.layer.cornerRadius = (self.frame.width + self.frame.height) / 2
        } else {
            self.layer.cornerRadius = 0
        }
    }
    
    private func setBorderColor() {
        self.layer.borderColor = self._borderColor.cgColor
    }
    
    private func setBorderWidth() {
        self.layer.borderWidth = self._borderWidth
    }
}
