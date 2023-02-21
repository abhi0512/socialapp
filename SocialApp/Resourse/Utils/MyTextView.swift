//
//  MyTextView.swift
//  RoadRez
//
//  Created by Abhishek Rathi on 29/10/19.
//  Copyright © 2019 Abhishek Rathi. All rights reserved.
//

import UIKit

class MyTextView: UITextView {
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        var superRect = super.caretRect(for: position)
        guard let font = self.font else { return superRect }
        
        // "descender" is expressed as a negative value,
        // so to add its height you must subtract its value
        superRect.size.height = font.pointSize - font.descender
        return superRect
    }
}
