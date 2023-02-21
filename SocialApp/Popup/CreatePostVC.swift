//
//  CreatePostVC.swift
//  SocialApp
//
//  Created by tis mac on 03/02/23.
//

import UIKit

class CreatePostVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Do any additional setup after loading the view.
    }

    @IBAction func btnCreatePostClick (sender : UIButton)
    {
        Constants.CreatePostPop.isok = "Y"
        self.dismiss(animated: true, completion: nil)
    }

}
