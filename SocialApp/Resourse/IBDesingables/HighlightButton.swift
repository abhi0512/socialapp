//
//  HighlightButton.swift
//  cabinetcounter
//
//  Created by Abhishek Rathi on 21/04/21.
//

import Foundation
import UIKit

@IBDesignable
class HighlightButton: UIButton {

    @IBInspectable
    var normalBackground: UIColor = .clear {
        didSet {
            backgroundColor = self.normalBackground
        }
    }

    @IBInspectable
    var highlightBackground: UIColor = .clear

    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? highlightBackground : normalBackground
        }
    }

    func setBackgroundColor(_ c: UIColor, forState: UIControl.State) -> Void {
        if forState == UIControl.State.normal {
            normalBackground = c
        } else if forState == UIControl.State.highlighted {
            highlightBackground = c
        } else {
            // implement other states as desired
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit() -> Void {

        // 1. rounded corners
       // self.layer.cornerRadius = 10.0

        // 2. Default Colors for state
        self.setBackgroundColor(.orange, forState: .normal)
        self.setBackgroundColor(.red, forState: .highlighted)

        // 3. Add the shadow
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.3
       // self.layer.shadowRadius = 4.0
        self.layer.masksToBounds = false

    }

}
