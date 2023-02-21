//
//  ChangePasswordVC.swift
//  SocialApp
//
//  Created by tis mac on 02/02/23.
//

import UIKit
import Loaf
import Firebase
import FirebaseFirestore

class ChangePasswordVC: UIViewController {
    
    @IBOutlet weak var txtoldPassword : DesignableUITextField!
    @IBOutlet weak var txtnewPassword : DesignableUITextField!
    @IBOutlet weak var txtconfirmPassword : DesignableUITextField!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.hideNavigationBar()
        sceneDelegate?.tabBarController.tabBar.isHidden = false
    }
    
    @IBAction func btnBack(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSave (sender : UIButton)
    {
        if self.txtoldPassword.text == ""
        {
            let message = "Please enter your old password"
            Loaf(message, state: .error, sender: self).show()
        }
        else if self.txtoldPassword.text == ""
        {
            let message = "Please enter your new password"
            Loaf(message, state: .error, sender: self).show()
        }
        else if self.txtoldPassword.text == ""
        {
            let message = "Please enter your confirm password"
            Loaf(message, state: .error, sender: self).show()
        }
        else
        {
            self.checkPassword()
        }
    }
    
    func checkPassword()
    {
        db.collection("Social").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for dict in querySnapshot!.documents {
                    print("\(dict.documentID) => \(dict.data())")
                    
                    let uid = dict.documentID
                    let password = dict["password"] as? String
                    
                    if self.txtoldPassword.text == password
                    {
                        if self.txtnewPassword.text == self.txtconfirmPassword.text
                        {
                            
                            let UpdatePassword = self.db.collection("Social").document(uid)
                            
                            UpdatePassword.updateData(["password" : self.txtconfirmPassword.text!]) { err in
                                if let err = err {
                                    print("Error updating document: \(err)")
                                } else {
                                    let message = "Password Change Successful"
                                    Loaf(message, state: .success, sender: self).show()
                                    self.txtnewPassword.text = ""
                                    self.txtconfirmPassword.text = ""
                                    self.txtoldPassword.text = ""
                                }
                            }
                        }
                        else
                        {
                            let message = "Password dose't match. Try agin"
                            Loaf(message, state: .error, sender: self).show()
                        }
                    }
                    else
                    {
                        let message = "old password is incorrect"
                        Loaf(message, state: .error, sender: self).show()
                    }
                }
            }
        }
    }
    
}
