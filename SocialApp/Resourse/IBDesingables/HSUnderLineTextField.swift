//
//  HSUnderLineTextField.swift
//  CincyBins
//
//  Created by Abhishek Rathi on 08/04/2020.
//  Copyright © 2020 Abhishek Rathi. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable

class HSUnderLineTextField: UITextField
{

    override func draw(_ rect: CGRect) {
           
           let borderLayer = CALayer()
           let widthOfBorder = getBorderWidht()
           borderLayer.frame = CGRect(x: -15, y: self.frame.size.height - widthOfBorder, width: self.frame.size.width+20, height: self.frame.size.height)
           borderLayer.borderWidth = widthOfBorder
           borderLayer.borderColor = getBottomLineColor()
           self.layer.addSublayer(borderLayer)
           self.layer.masksToBounds = true
           
       }
       
       
       
       //MARK : set the image LeftSide
       @IBInspectable var SideImage:UIImage? {
           didSet{
           
               
            let leftAddView = UIView.init(frame: CGRect(x: 0, y: 0, width: 25, height: self.frame.size.height-15))
            let leftimageView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 18, height: 18))//Create a imageView for left side.
               leftimageView.image = SideImage
            leftimageView.contentMode = .scaleAspectFit
               leftAddView.addSubview(leftimageView)
               self.leftView = leftAddView
            self.leftViewMode = UITextField.ViewMode.always
           }
           
       }
    @IBInspectable var bottomLineColor: UIColor = UIColor.black {
           didSet {
               
           }
       }
       
       
       func getBottomLineColor() -> CGColor {
        return bottomLineColor.cgColor;
           
       }
       @IBInspectable var cusborderWidth:CGFloat = 1.0
           {
           didSet{
               
           }
       }
       
       func getBorderWidht() -> CGFloat {
           return cusborderWidth;
           
       }
}
