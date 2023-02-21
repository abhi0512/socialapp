//
//  ViewController.swift
//  SocialApp
//
//  Created by tis mac on 31/01/23.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "Roboto-Medium", size: 15)!]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "Roboto-Medium", size: 15)!]
        let normal = NSAttributedString(string: text, attributes: attrs)
        append(normal)
        return self
    }
}


