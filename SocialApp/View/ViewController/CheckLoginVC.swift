//
//  CheckLoginVC.swift
//  SocialApp
//
//  Created by tis mac on 01/02/23.
//

import UIKit
import Loaf
import Firebase
import FirebaseFirestore

class CheckLoginVC: UIViewController {

    var email = ""
    var password = ""
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checklogin()
        // Do any additional setup after loading the view.
    }
   
    override func viewWillAppear(_ animated: Bool) {
        self.hideNavigationBar()
    }
    
    func checklogin()
    {
        var userdata = NSMutableArray()
        userdata = DbHandler.fetchuserdetail()
        if(userdata.count > 0)
        {
            self.email = ((userdata[0] as AnyObject).value(forKey: "email") as? String)!
            self.password = ((userdata[0] as AnyObject).value(forKey: "password") as? String)!
            print(self.email)
            print(self.password)
            self.CheckLogingUser()
        }
    }
    
    func CheckLogingUser()
    {
        db.collection("Social").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for dict in querySnapshot!.documents {
                    print("\(dict.documentID) => \(dict.data())")
                    
                    let userID = dict.documentID
                    let firstname = dict["firstname"] as? String
                    let lastname = dict["lastname"] as? String
                    let email = dict["email"] as? String
                    let password = dict["password"] as? String
                    let profile_img = dict["Profile_img"] as? String

                    if self.email == email && self.password == password
                    {
                        DbHandler.deleteDatafromtable("delete from tbluser")
                        GlobalVariables.sharedManager.memberid = dict.documentID

                        let flg = DbHandler.insertuser(userID, firstname: firstname!, lastname: lastname!, email: email!, profileimage: profile_img, password: password!)

                        if flg == true
                        {
                            sceneDelegate?.tabBarController.tabBar.isHidden = false
                            sceneDelegate?.SetRootControler()
                        }
                    }
                    else
                    {
                        let openview = LoginVC()
                        self.push(viewController: openview)
                    }
                }
            }
        }
    }
}
