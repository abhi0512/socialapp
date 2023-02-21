//
//  LoginVC.swift
//  SocialApp
//
//  Created by tis mac on 31/01/23.
//

import UIKit
import SCLAlertView
import ActiveLabel
import Loaf
import Firebase
import FirebaseFirestore

class LoginVC: UIViewController {
    
    @IBOutlet weak var txtEmail: DesignableUITextField!
    @IBOutlet weak var txtPassword: DesignableUITextField!
    @IBOutlet weak var BtnLogin: UIButton!
    @IBOutlet weak var lblsignup: ActiveLabel!
    @IBOutlet weak var lblLoginIn: ActiveLabel!
    
    var arrUser = [UserModel]()
    let db = Firestore.firestore()
    
    var ref = DatabaseReference.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.txtEmail.text = "tisinfosoft01+1@gmail.com"
        self.txtPassword.text = "123456789"
        self.ref = Database.database().reference()
        self.BtnLogin.layer.cornerRadius = 10
        self.setuptext()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.hideNavigationBar()
        sceneDelegate?.tabBarController.tabBar.isHidden = true
    }
    
    func setuptext()
    {
        let formattedString = NSMutableAttributedString()
        formattedString
            .normal("Forgotten you login details? ")
            .bold(" Get help with logging in.")
        let customType1 = ActiveType.custom(pattern: "\\sGet help with logging in.\\b")
        self.lblLoginIn.enabledTypes = [.url, customType1]
        self.lblLoginIn.textColor = UIColor.init(hexString: "#505050")
        self.lblLoginIn.attributedText = formattedString
        self.lblLoginIn.customColor[customType1] = UIColor.init(hexString: "#06467A")
        self.lblLoginIn.customSelectedColor[customType1] = UIColor.init(hexString: "#06467A")
        
        self.lblLoginIn.handleCustomTap(for: customType1) { element in
            print("Custom type tapped: \(element)")
            //            if let url = NSURL(string: "https://style-up-beauty-solutions.be/pdf/term-conditions-\(lang).pdf"){
            //                if #available(iOS 10, *){
            //                    UIApplication.shared.open(url as URL)
            //                }else{
            //                    UIApplication.shared.openURL(url as URL)
            //                }
            //            }
        }
        
        let formattedString1 = NSMutableAttributedString()
        formattedString1
            .normal("Don’t have an account?")
            .bold(" Sign up.")
        
        let customType = ActiveType.custom(pattern: "\\Sign up.\\b") //Regex that3 looks for "with"
        self.lblsignup.enabledTypes = [.url, customType]
        self.lblsignup.textColor = UIColor.init(hexString: "#505050")
        self.lblsignup.attributedText = formattedString1
        self.lblsignup.customColor[customType] = UIColor.init(hexString: "#06467A")
        self.lblsignup.customSelectedColor[customType] = UIColor.init(hexString: "#06467A")
        
        self.lblsignup.handleCustomTap(for: customType) { element in
            print("Custom type tapped: \(element)")
            let openview = LoginVC()
            self.push(viewController: openview)
        }
    }
    
    @IBAction func btnSignUpClick (sender : UIButton)
    {
        let openview = SignUpVC()
        self.push(viewController: openview)
    }
    
    @IBAction func btnloginClick (sender : UIButton)
    {
        
        if self.txtEmail.text == ""
        {
            let message = "Enter your email"
            Loaf(message, state: .error, sender: self).show()
        }
        else if self.txtPassword.text == ""
        {
            let message = "Enter your password"
            Loaf(message, state: .error, sender: self).show()
        }
        else
        {
            self.CheckLogingUser()
        }
    }
    
    func CheckLogingUser()
    {
        db.collection(Constants.Social).whereField("email", isEqualTo: self.txtEmail.text!)
            .whereField("password", isEqualTo: self.txtPassword.text!).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    if querySnapshot!.documents.count == 0
                    {
                        let message = "Your email and password incorret "
                        Loaf(message, state: .error, sender: self).show()
                    }
                    else
                    {
                        for dict in querySnapshot!.documents {
                            print("\(dict.documentID) => \(dict.data())")
                            
                            let userID = dict.documentID
                            let firstname = dict["firstname"] as? String
                            let lastname = dict["lastname"] as? String
                            let email = dict["email"] as? String
                            let password = dict["password"] as? String
                            let profile_img = dict["Profile_img"] as? String
                            
                            
                            DbHandler.deleteDatafromtable("delete from tbluser")
                            GlobalVariables.sharedManager.memberid = dict.documentID
                            
                            let flg = DbHandler.insertuser(userID, firstname: firstname!, lastname: lastname!, email: email!, profileimage: profile_img, password: password!)
                            
                            if flg == true
                            {
                                sceneDelegate?.tabBarController.tabBar.isHidden = false
                                sceneDelegate?.SetRootControler()
                            }
                        }
                    }
                    

                }
            }
    }
    
}
