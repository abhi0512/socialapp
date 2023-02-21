//
//  UIViewController+KeyboardDismissable.swift
//  Aeryus
//
//  Created by Wang Gang on 9/12/18.
//  Copyright © 2018 Aeryus. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // Dismiss keyboard by tapping outside of TextFields
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismissKeyboard()
    }
    
    // Function to dismiss keyboard
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
