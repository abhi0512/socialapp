//
//  SignUpVC.swift
//  SocialApp
//
//  Created by tis mac on 31/01/23.
//

import UIKit
import SCLAlertView
import ActiveLabel
import Firebase
import Loaf
import FirebaseFirestore

class SignUpVC: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate
 {

    @IBOutlet weak var txtFirstName: DesignableUITextField!
    @IBOutlet weak var txtLastName: DesignableUITextField!
    @IBOutlet weak var txtEmail: DesignableUITextField!
    @IBOutlet weak var txtPassword: DesignableUITextField!
    @IBOutlet weak var BtnSingUp: UIButton!
    @IBOutlet weak var lblAlreadyAccount: ActiveLabel!
    
    var ImagePicker = UIImagePickerController()
  
    let db = Firestore.firestore()
    
    var arrEmail = [EmailModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.BtnSingUp.layer.cornerRadius = 10
        
        let formattedString = NSMutableAttributedString()
        formattedString
            .normal("Already have a account?")
            .bold(" Log In")
        
        let customType = ActiveType.custom(pattern: "\\sLog In\\b") //Regex that3 looks for "with"
        self.lblAlreadyAccount.enabledTypes = [.url, customType]
        self.lblAlreadyAccount.textColor = UIColor.init(hexString: "#505050")
        self.lblAlreadyAccount.attributedText = formattedString
        self.lblAlreadyAccount.customColor[customType] = UIColor.init(hexString: "#06467A")
        self.lblAlreadyAccount.customSelectedColor[customType] = UIColor.init(hexString: "#06467A")
        
        self.lblAlreadyAccount.handleCustomTap(for: customType) { element in
            print("Custom type tapped: \(element)")
            let openview = LoginVC()
            self.push(viewController: openview)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.hideNavigationBar()
    }
    
    @IBAction func btnSignUpClick (sender : UIButton)
    {
        if self.txtFirstName.text == ""
        {
           let message = "Enter your first name"
            Loaf(message, state: .error, sender: self).show()
        }
        else if self.txtLastName.text == ""
        {
           let message = "Enter your last name"
            Loaf(message, state: .error, sender: self).show()
        }
        else if self.txtEmail.text == ""
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
        Auth.auth().createUser(withEmail: self.txtEmail.text!, password: self.txtPassword.text! ) { user, error in
            if let x = error {
                let err = x as NSError
                switch err.code {
                case AuthErrorCode.wrongPassword.rawValue:
                    let message = "wrong password"
                    Loaf(message, state: .error, sender: self).show()
                case AuthErrorCode.invalidEmail.rawValue:
                    let message = "invalid email"
                    Loaf(message, state: .error, sender: self).show()
                case AuthErrorCode.accountExistsWithDifferentCredential.rawValue:
                    let message = "accountExistsWithDifferentCredential"
                    Loaf(message, state: .error, sender: self).show()
                case AuthErrorCode.emailAlreadyInUse.rawValue: //<- Your Error
                    let message = "email is alreay in use"
                    Loaf(message, state: .error, sender: self).show()
                default:
                    let message = "unknown error: \(err.localizedDescription)"
                    Loaf(message, state: .error, sender: self).show()
                }
            }
            else
            {
                let dict = ["firstname": self.txtFirstName.text!, "lastname": self.txtLastName.text!, "email": self.txtEmail.text! , "password": self.txtPassword.text!, "bio": "" , "Profile_img" :""]
                print(dict)
                
                self.db.collection(Constants.Social).addDocument(data: dict) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        let openview = LoginVC()
                        self.push(viewController: openview)
                    }
                }
            }
        }
    }
}
