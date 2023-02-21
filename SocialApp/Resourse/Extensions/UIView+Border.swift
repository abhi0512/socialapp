//
//  UIView+Border.swift
//  Aeryus
//
//  Created by Wang Gang on 9/12/18.
//  Copyright © 2018 Aeryus. All rights reserved.
//

import UIKit

extension UIView {
    
    // Example use: myView.addBorder(toSide: .Left, withColor: UIColor.redColor().CGColor, andThickness: 1.0)
    
    enum ViewSide {
        case left, right, top, bottom
    }
    
    func addTopBorder(width: CGFloat, color: UIColor, offset: CGFloat = 0.0) {
        let bottomBorderView = UIView(frame: .zero)
        bottomBorderView.backgroundColor = color
        addSubview(bottomBorderView)
        
        bottomBorderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomBorderView.leftAnchor.constraint(equalTo: leftAnchor),
            bottomBorderView.rightAnchor.constraint(equalTo: rightAnchor),
            bottomBorderView.topAnchor.constraint(equalTo: topAnchor, constant: offset),
            bottomBorderView.heightAnchor.constraint(equalToConstant: width)
            ])
    }
    
    func addBottomBorder(width: CGFloat, color: UIColor, offset: CGFloat = 0.0, size: CGFloat = 0.0) {
        let bottomBorderView = UIView(frame: .zero)
        bottomBorderView.backgroundColor = color
        addSubview(bottomBorderView)
        
        bottomBorderView.translatesAutoresizingMaskIntoConstraints = false
        
        if size == 0.0 {
            NSLayoutConstraint.activate([
                bottomBorderView.leftAnchor.constraint(equalTo: leftAnchor),
                bottomBorderView.rightAnchor.constraint(equalTo: rightAnchor),
                bottomBorderView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: offset),
                bottomBorderView.heightAnchor.constraint(equalToConstant: width)
                ])
        } else {
            NSLayoutConstraint.activate([
                bottomBorderView.widthAnchor.constraint(equalToConstant: size),
                bottomBorderView.centerXAnchor.constraint(equalTo: centerXAnchor),
                bottomBorderView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: offset),
                bottomBorderView.heightAnchor.constraint(equalToConstant: width)
                ])
        }
    }
    
    
    
    func addRightBorder(width: CGFloat, color: UIColor, offset: CGFloat = 0.0) {
        let bottomBorderView = UIView(frame: .zero)
        bottomBorderView.backgroundColor = color
        addSubview(bottomBorderView)
        
        bottomBorderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomBorderView.topAnchor.constraint(equalTo: topAnchor),
            bottomBorderView.rightAnchor.constraint(equalTo: rightAnchor, constant: -offset),
            bottomBorderView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomBorderView.widthAnchor.constraint(equalToConstant: width)
            ])
    }
    
    func addBorder(toSide side: ViewSide, withColor color: CGColor, andThickness thickness: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = color
        border.zPosition = 100
        
        switch side {
        case .left: border.frame = CGRect(x: frame.minX, y: frame.minY, width: thickness, height: frame.height); break
        case .right: border.frame = CGRect(x: frame.maxX - thickness, y: frame.minY, width: thickness, height: frame.height); break
        case .top: border.frame = CGRect(x: frame.minX, y: frame.minY, width: frame.width, height: thickness); break
        case .bottom: border.frame = CGRect(x: frame.minX, y: frame.maxY - thickness, width: frame.width, height: thickness); break
        }
        
        layer.addSublayer(border)
    }
}

