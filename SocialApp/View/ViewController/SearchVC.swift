//
//  SearchVC.swift
//  SocialApp
//
//  Created by tis mac on 01/02/23.
//

import UIKit

class SearchVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.hideNavigationBar()
        sceneDelegate?.tabBarController.tabBar.isHidden = false
    }
    
}
