//
//  PostVC.swift
//  SocialApp
//
//  Created by tis mac on 03/02/23.
//

import UIKit
import Loaf
import FirebaseFirestore
import FirebaseStorage

class PostVC: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    @IBOutlet weak var Post_image : UIImageView!
    @IBOutlet weak var txtAddCaption : UITextView!
    @IBOutlet weak var txtAddCaptionView : UIView!
    var ImagePicker = UIImagePickerController()
    var selectedimage = UIImage()
    var Documentid = ""
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Post_image.image = self.selectedimage
        self.txtAddCaptionView.layer.borderWidth = 1
        self.txtAddCaptionView.layer.borderColor = UIColor.init(hexString: "#808080")?.cgColor
        self.txtAddCaptionView.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }

    @IBAction func btnPost (sender : UIButton)
    {
        self.postUpload()
    }
    
    func postUpload()
    {
        self.uplodeimage(image: self.Post_image.image!) { (url) in
            self.PostImage(profileimage: url!) { (success) in
                if success != nil
                {
                    print("yes")
                }
            }
        }
    }
    
    func PostImage(profileimage : URL , completion : @escaping ((_ url : URL?) -> ()))
    {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = df.string(from: date)
        
        let dict = ["Userid": GlobalVariables.sharedManager.memberid , "Caption": self.txtAddCaption.text!, "Post_date_time": dateString, "Post_img": profileimage.absoluteString] as [String : Any]
        
        
        self.db.collection(Constants.UserPost).addDocument(data: dict)  { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document successfully written!")
                let message = "Post upload successfully"
                Loaf(message, state: .success, sender: self ).show(.custom(1))
                {_ in
                    let openview = HomeVC()
                    self.push(viewController: openview)
                }
            }
        }
    }
     
    func uplodeimage(image : UIImage , completion : @escaping ((_ url : URL?) -> ()))
    {
        let storageref = Storage.storage().reference().child("myimage.png")
        let imgData = image.pngData()
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
    
    @IBAction func btnBack(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
}
