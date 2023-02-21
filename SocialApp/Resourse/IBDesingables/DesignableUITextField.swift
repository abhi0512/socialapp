//
//  DesignableUITextField.swift
//  RoadRez
//
//  Created by Abhishek Rathi on 24/06/19.
//  Copyright © 2019 Abhishek Rathi. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableUITextField: UITextField {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.borderStyle = .none
        updateView()
        updaterightView()
        setExtraGraphics()
    }
    @IBInspectable var textbgcolor: UIColor = UIColor.init(hexString: "#040402")! {
        didSet{
            
        }
    }
    
    @IBInspectable var textbordercolor: UIColor = UIColor.init(hexString: "#ffffff")! {
        didSet{
            
        }
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var rightImage: UIImage? {
        didSet {
            updaterightView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0
    
    @IBInspectable var rightPadding: CGFloat = 0

    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + leftPadding, y: bounds.origin.y, width: bounds.size.width - leftPadding - rightPadding, height: bounds.size.height)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
            updaterightView()
        }
    }
   
    func setExtraGraphics() {
        //self.backgroundColor = UIColor(red: 0.27, green: 0.36, blue: 0.4, alpha: 1.0)
        self.backgroundColor = UIColor.init(hexString: "#f3f5f9")
        self.backgroundColor = textbgcolor
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.layer.borderColor = textbordercolor.cgColor
        //self.layer.borderColor = UIColor.clear.cgColor //UIColor.init(hexString: "#2f3273")?.cgColor
       // dropShadow()
    }
    
    func dropShadow(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.init(hexString: "#f3f5f9")?.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 10)
        self.layer.shadowRadius = 10
        
        self.layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        self.layer.shouldRasterize = false
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    private var shadowLayer: CAShapeLayer!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if shadowLayer == nil {
//            shadowLayer = CAShapeLayer()
//            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 0).cgPath
//              shadowLayer.fillColor = UIColor.init(hexString: "#efefef")?.cgColor
//            shadowLayer.shadowColor = UIColor.black.cgColor
//            shadowLayer.shadowPath = shadowLayer.path
//            shadowLayer.shadowOffset = CGSize(width: 0, height: 2.0)
//            shadowLayer.shadowOpacity = 0.06
//            shadowLayer.shadowRadius = 3
//
//            layer.insertSublayer(shadowLayer, at: 0)
            //layer.insertSublayer(shadowLayer, below: nil) // also works
        }
    }
    
    func updaterightView() {
        if let image = rightImage {
            rightViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 18, height: 18))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            let viewRight: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 33, height: 20))
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            viewRight.addSubview(imageView)
            rightView = viewRight
        } else {
            rightViewMode = UITextField.ViewMode.never
            rightView = nil
        }
        
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])
    }
    
    func updateView() {
        if let image = leftImage {
            leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 15, y: 0, width: 18, height: 18))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            let viewLeft: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 33, height: 20))
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            viewLeft.addSubview(imageView)
            leftView = viewLeft
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }
        
        //textbg color
        
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])
    }
}
