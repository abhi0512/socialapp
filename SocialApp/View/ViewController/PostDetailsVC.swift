//
//  PostDetailsVC.swift
//  SocialApp
//
//  Created by tis mac on 06/02/23.
//

import UIKit
import Loaf
import FirebaseFirestore
import FirebaseStorage
class IntrinsicTableView: UITableView {

    override var contentSize:CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }
}
class PostDetailsVC: UIViewController{
    
    @IBOutlet weak var userprofileimg : UIImageView!
    {
        didSet
        {
            userprofileimg.layer.cornerRadius = (userprofileimg.frame.height) / 2
        }
    }

    var arrCmnt = [CommentModel]()
   
    @IBOutlet weak var postimg : UIImageView!
    @IBOutlet weak var lblusername : UILabel!
    @IBOutlet weak var btnshare : UIButton!
    @IBOutlet weak var btnlike : UIButton!
    @IBOutlet weak var btncmt : UIButton!
    @IBOutlet weak var lbllike : UILabel!
    @IBOutlet weak var lblcmtCnt : UILabel!
    @IBOutlet weak var lbldate : UILabel!
    @IBOutlet weak var lbldescription : UILabel!
    @IBOutlet weak var lbldescriptionHt : NSLayoutConstraint!
    
    var arrgetPost = [HomePagePostModel]()
    let db = Firestore.firestore()
    var postid = ""
    var userid = ""
    var postlike = "N"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblcmtCnt.isHidden = true
        self.postimg.layer.cornerRadius = 8
        self.getPostDetalis()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.hideNavigationBar()
        sceneDelegate?.tabBarController.tabBar.isHidden = true
    }
   
    func getPostDetalis()
    {
        db.collection(Constants.UserPost).document(postid).addSnapshotListener { (documentSnapshot, err) in
            
            guard let document = documentSnapshot else {
                print("Error fetching document: \(err!)")
                return
            }
            
            guard let dict = document.data() else {
                print("Document data was empty.")
                return
            }
            
            let img = dict["Post_img"] as? String
            let Caption = dict["Caption"] as? String
            let PostDateTime = dict["Post_date_time"] as? String
            let userid = (dict["Userid"] as? String)!
            
            self.getLikeCount()
            self.UserDetalis(userid : userid)
            self.postimg.sd_setImage(with: URL(string: img!), placeholderImage: UIImage(named: "icon"))
            if Caption != ""
            {
                self.lbldescriptionHt.constant = 30
            }
            
            self.lbldescription.text = Caption
            self.lbldate.text = PostDateTime
        }
    }
    
    func UserDetalis(userid : String)
    {
        db.collection(Constants.Social).document(userid).addSnapshotListener { (documentSnapshot, err) in
            
            guard let document = documentSnapshot else {
                print("Error fetching document: \(err!)")
                return
            }
            
            guard let dict = document.data() else {
                print("Document data was empty.")
                return
            }
            
            let firstname = dict["firstname"] as? String
            let lastname = dict["lastname"] as? String
            let profileimg = (dict["Profile_img"] as? String)!
            let username = "\(firstname ?? "") \(lastname ?? "")"
            self.CheckPostLike()
            self.getCmntList()
            self.lblusername.text = username
            if profileimg == ""
            {
                self.userprofileimg.image = UIImage.init(named: "no_image")
            }
            else
            {
                self.userprofileimg.sd_setImage(with: URL(string: profileimg), placeholderImage: UIImage(named: "icon"))
            }
        }
    }
    
    @IBAction func btnBack(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnLike(sender : UIButton)
    {
        if self.postlike == "N"
        {
            self.btnlike.setImage(UIImage.init(named:"like"), for: .normal)
        }
        else
        {
            self.btnlike.setImage(UIImage.init(named:"dislike"), for: .normal)
        }
        self.postLikeDislike()
    }
    
    func postLikeDislike()
    {
        if self.postlike == "Y"
        {
            db.collection(Constants.LikePost).whereField("Userid", isEqualTo: GlobalVariables.sharedManager.memberid)
                .whereField("Postid", isEqualTo: postid).getDocuments()
            { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else
                {
                    var id = ""
                    for i in querySnapshot!.documents{
                        id = i.documentID
                        self.deleteDocument(Mainclass: Constants.LikePost, subClass: id)
                        self.postlike = "N"
                        self.getLikeCount()
                    }
                }
            }
        }
        else
        {
            let date = Date()
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            let dateString = df.string(from: date)
            
            let dict = ["Userid": GlobalVariables.sharedManager.memberid, "Postid": postid,"date": dateString] as [String : Any]
            
            self.db.collection(Constants.LikePost).addDocument(data: dict) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Post Like")
                }
            }
            self.postlike = "Y"
            self.getLikeCount()
        }
    }
    
    func CheckPostLike()
    {
        db.collection(Constants.LikePost).whereField("Userid", isEqualTo: GlobalVariables.sharedManager.memberid)
        .whereField("Postid", isEqualTo: self.postid).getDocuments()
        { (querySnapshot, err) in
            var postlikr = "N"
            
            if let err = err
            {
                print("Error getting documents: \(err)")
            }
            else
            {
                var id = ""
                for j in querySnapshot!.documents{
                    id = j.documentID
                    postlikr = "Y"
                }
                self.postlike = postlikr
                if self.postlike == "Y"
                {
                    self.btnlike.setImage(UIImage.init(named:"like"), for: .normal)
                }
                else
                {
                    self.btnlike.setImage(UIImage.init(named:"dislike"), for: .normal)
                }
            }
        }
    }
    
    func getLikeCount()
    {
        var Likecnt = ""
        db.collection(Constants.LikePost)
            .whereField("Postid", isEqualTo: self.postid).getDocuments()
        { (querySnapshot, err) in
                
            if let err = err
            {
                print("Error getting documents: \(err)")
            }
            else
            {
                Likecnt = "\(querySnapshot!.documents.count)"
                print("like : \(Likecnt)")
                    
                if Likecnt == ""
                {
                    self.lbllike.isHidden = true
                }
                else if Likecnt == "1"
                {
                    self.lbllike.text = "\(Likecnt)"
                }
                else
                {
                    self.lbllike.text = "\(Likecnt)"
                }
            }
        }
    }
    
    @IBAction func btnShowCmnt (sender : UIButton)
    {
        let openview = CommentVC()
        openview.postid = self.postid
        self.push(viewController: openview)
    }
    
    func getCmntList()
    {
        self.db.collection(Constants.PostComment).whereField("Postid", isEqualTo: self.postid).getDocuments { (querySnapshot, err) in
            
            if let err = err
            {
                print("Error getting documents: \(err)")
            }
            else
            {
                if querySnapshot!.documents.count == 0
                {
                    self.lblcmtCnt.isHidden = true
                }
                else
                {
                    self.lblcmtCnt.isHidden = false
                    self.lblcmtCnt.text = "\(querySnapshot!.documents.count)"
                }
            }
        }
    }
}
