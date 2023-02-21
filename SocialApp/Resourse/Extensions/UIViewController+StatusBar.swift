//
//  UIViewController+StatusBar.swift
//  Aeryus
//
//  Created by Wang Gang on 9/12/18.
//  Copyright © 2018 Aeryus. All rights reserved.
//

import UIKit

extension UIViewController {
    
    /**
     Show status bar with style
     */
    func showStatusBar(style: UIStatusBarStyle = .default) {
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.statusBarStyle = style
    }
    
    /**
     Hide status bar
     */
    func hideStatusBar() {
        UIApplication.shared.isStatusBarHidden = true
    }
    
    
}
