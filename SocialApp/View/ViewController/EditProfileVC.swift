//
//  EditProfileVC.swift
//  SocialApp
//
//  Created by tis mac on 01/02/23.
//

import UIKit
import SDWebImage
import Loaf
import Firebase
import FirebaseFirestore
import FirebaseStorage

class EditProfileVC: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {

    @IBOutlet weak var ProfileImage : UIImageView!
    @IBOutlet weak var txtAddBioView : UIView!
    @IBOutlet weak var txtfirstname : DesignableUITextField!
    @IBOutlet weak var txtlastname : DesignableUITextField!
    @IBOutlet weak var txtAddBio : UITextView!
    
    var ImagePicker = UIImagePickerController()
    var Documentid = ""
    let db = Firestore.firestore()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getUserData()
        self.ProfileImage.layer.cornerRadius = (self.ProfileImage.frame.height) / 2
        self.txtAddBioView.layer.borderWidth = 1
        self.txtAddBioView.layer.borderColor = UIColor.init(hexString: "#808080")?.cgColor
        self.txtAddBioView.layer.cornerRadius = 10
        
        let tapImage = UITapGestureRecognizer(target: self, action: #selector(UplodeImage))
        self.ProfileImage.isUserInteractionEnabled = true
        self.ProfileImage.addGestureRecognizer(tapImage)
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.hideNavigationBar()
    }
    
    @IBAction func btnSaveClick (sender : UIButton)
    {
        if self.txtfirstname.text == ""
        {
            let message = "Please enter your first name"
            Loaf(message, state: .error, sender: self).show()
        }
        else if self.txtlastname.text == ""
        {
            let message = "Please enter your last name"
            Loaf(message, state: .error, sender: self).show()
        }
        else if self.txtAddBio.text == ""
        {
            let message = "Please enter your bio"
            Loaf(message, state: .error, sender: self).show()
        }
        else
        {
            self.updateProfile()
        }
    }
    
    func getUserData()
    {
        db.collection(Constants.Social).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for dict in querySnapshot!.documents {
                    print("\(dict.documentID) => \(dict.data())")
                    
                    self.Documentid = dict.documentID
                    self.txtfirstname.text = dict["firstname"] as? String
                    self.txtlastname.text = dict["lastname"] as? String
                    self.txtAddBio.text = dict["bio"] as? String
                    let img = dict["Profile_img"] as? String
                    
                    if img != ""
                    {
                        self.ProfileImage.sd_showActivityIndicatorView()
                        self.ProfileImage.sd_setImage(with: URL(string: img!), placeholderImage: UIImage(named: "icon"))
                    }
                    else
                    {
                        self.ProfileImage.image = UIImage.init(named: "no_image")
                    }
                }
            }
        }
    }
    
    func updateProfile()
    {
        self.uplodeimage(image: self.ProfileImage.image!) { (url) in
            self.updateDetails(profileimage: url!) { (success) in
                if success != nil
                {
                    print("yes")
                }
            }
        }
    }
    
    func updateDetails(profileimage : URL , completion : @escaping ((_ url : URL?) -> ()))
    {
        let dict = ["firstname": self.txtfirstname.text!, "lastname": self.txtlastname.text!, "bio": self.txtAddBio.text!, "Profile_img": profileimage.absoluteString] as [String : Any]
        
        let UpdateUserDetails = db.collection(Constants.Social).document(self.Documentid)
        
        
        UpdateUserDetails.updateData(dict) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    @objc func UplodeImage(sender:UITapGestureRecognizer)
    {
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Select Option", message: "", preferredStyle: .actionSheet)
    let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
           
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        let saveActionButton = UIAlertAction(title: "Camera", style: .default)
        { _ in
            
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
            {
                self.ImagePicker.sourceType = UIImagePickerController.SourceType.camera
                self.ImagePicker.delegate = self
                self .present(self.ImagePicker, animated: true, completion: nil)
            }
        }
        actionSheetControllerIOS8.addAction(saveActionButton)
      
        let deleteActionButton = UIAlertAction(title: "Gallery", style: .default)
        { _ in
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                print("Button capture")
                self.ImagePicker.delegate = self
                self.ImagePicker.sourceType = .savedPhotosAlbum
                self.present(self.ImagePicker, animated: true, completion: nil)
            }
        }
        actionSheetControllerIOS8.addAction(deleteActionButton)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
      let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
       self.ProfileImage.image = image
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnBack(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
}

extension EditProfileVC
{
    func uplodeimage(image : UIImage , completion : @escaping ((_ url : URL?) -> ()))
    {
        let storageref = Storage.storage().reference().child("myimage.png")
        let imgData = self.ProfileImage.image?.pngData()
        let meteData = StorageMetadata()
        meteData.contentType = "image/png"
        storageref.putData(imgData!, metadata: meteData) { (metadata, error) in
            if error == nil
            {
                print("success")
                storageref.downloadURL { (url, error) in
                    completion(url)
                }
            }
            else
            {
                print("error in save image")
            }
        }
    }
}
