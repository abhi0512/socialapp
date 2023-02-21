//
//  ViewUserProfileVC.swift
//  SocialApp
//
//  Created by tis mac on 10/02/23.
//

import UIKit
import FirebaseFirestore

class ViewUserProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let db = Firestore.firestore()
    var arrgetPost = [UserProfileModel]()
    
    @IBOutlet weak var userprofileimg : UIImageView!
    {
        didSet
        {
            userprofileimg.layer.cornerRadius = (userprofileimg.frame.height) / 2
        }
    }
    @IBOutlet weak var lblPostCnt : UILabel!
    @IBOutlet weak var lblFollowersCnt : UILabel!
    @IBOutlet weak var lblFollowingCnt : UILabel!
    @IBOutlet weak var lblUserName : UILabel!
    @IBOutlet weak var lblBio : UILabel!
    @IBOutlet weak var tblView : UITableView!
    @IBOutlet weak var sclView : UIScrollView!
    @IBOutlet weak var tblViewHT : NSLayoutConstraint!
    @IBOutlet weak var lblBioHT : NSLayoutConstraint!
    @IBOutlet weak var lblBioTopHT : NSLayoutConstraint!
    @IBOutlet weak var btnFollow : UIButton!
    let cellIdentifier = "cellIdentifier"
    var arrPost = [PostModel]()
    var userid = ""
    var username = ""
    var userProfile = ""
    var tapbuttonFollow = ""
    var tapbuttonFollowing = ""
    
    var LoginUserfollow = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.userid == GlobalVariables.sharedManager.memberid
        {
            self.btnFollow.isHidden = true
        }
        else
        {
            self.btnFollow.isHidden = false
        }
        
        self.sclView.isHidden = true
        self.btnFollow.layer.cornerRadius = 10
        self.getUserDetails()
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.lblclick))
        self.lblFollowersCnt.isUserInteractionEnabled = true
        self.tapbuttonFollow = "0"
        self.lblFollowersCnt.addGestureRecognizer(gesture)
        let gesture1 = UITapGestureRecognizer(target: self, action:  #selector(self.lblclick1))
        self.lblFollowingCnt.isUserInteractionEnabled = true
        self.tapbuttonFollowing = "1"
        self.lblFollowingCnt.addGestureRecognizer(gesture1)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.hideNavigationBar()
        sceneDelegate?.tabBarController.tabBar.isHidden = true
    }
    
    override func viewWillLayoutSubviews() {
    super.updateViewConstraints()
    self.tblViewHT?.constant = self.tblView.contentSize.height
    }
    
    @objc func lblclick (sender : UITapGestureRecognizer)
    {
        let openview = ViewFollowFollowingListVC()
        openview.tapButton = self.tapbuttonFollow
        openview.userid = self.userid
        self.push(viewController: openview)
    }
    @objc func lblclick1 (sender : UITapGestureRecognizer)
    {
        let openview = ViewFollowFollowingListVC()
        openview.userid = self.userid
        openview.tapButton = self.tapbuttonFollowing
        self.push(viewController: openview)
    }
    
    func getUserDetails()
    {
        db.collection(Constants.Social).document(self.userid).getDocument { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else
            {
                guard let document = querySnapshot else {
                print("Error fetching document: \(err!)")
                return
            }
                
                guard let dict = document.data() else {
                    print("Document data was empty.")
                    return
                }
                let firstname = dict["firstname"] as? String
                let lastname = dict["lastname"] as? String
                self.userProfile = (dict["Profile_img"] as? String)!
                let bio = dict["bio"] as? String
                self.getFollowFollowingList()
                self.getUserPost()
                self.username = "\(firstname ?? "") \(lastname ?? "")"
                self.lblUserName.text = self.username
                
                if bio == ""
                {
                    self.lblBioHT.constant = 0
                    self.lblBioTopHT.constant = 0
                }
                self.lblBio.text = bio
                
                if self.userProfile == ""
                {
                    self.userprofileimg.image = UIImage.init(named: "no_image")
                }
                else
                {
                    self.userprofileimg.sd_setImage(with: URL(string: self.userProfile), placeholderImage: UIImage(named: "icon"))
                }
            }
        }
    }
    
    func getUserPost()
    {
        db.collection(Constants.UserPost).whereField("Userid", isEqualTo: self.userid).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.arrPost.removeAll()
                for dict in querySnapshot!.documents {
                    print("\(dict.documentID) => \(dict.data())")
                    
                    let postID = dict.documentID
                    let Userid = dict["Userid"] as? String
                    let Caption = dict["Caption"] as? String
                    let Post_date_time = dict["Post_date_time"] as? String
                    let Post_img = dict["Post_img"] as? String
                    
                    self.arrPost.append(PostModel(UserId: Userid!, PostId: postID, Caption: Caption!, Post_date_time: Post_date_time!, Post_img: Post_img!))
                }
                self.lblPostCnt.text = "\(querySnapshot!.documents.count)"
                
                if self.arrPost.count > 0
                {
                    self.getPostLike()
                }
            }
        }
    }
    
    func getPostLike()
    {
        self.arrgetPost.removeAll()
        for i in (0..<self.arrPost.count)
        {
            db.collection(Constants.LikePost).whereField("Postid", isEqualTo: self.arrPost[i].PostId!).getDocuments()
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
                }
                
                let obj = self.arrPost[i]
                self.arrgetPost.append(UserProfileModel(UserId: obj.UserId!, PostId: obj.PostId!, Caption: obj.Caption!, Post_date_time: obj.Post_date_time!, Post_img: obj.Post_img!, Like_cnt: "", isLikePost: postlikr))
                self.getLikeCount()
                
                if self.arrgetPost.count > 0
                {
                    self.tblView.reloadData()
                    self.sclView.isHidden = false
                }
            }
        }
    }
    
    func getLikeCount()
    {
        for i in (0..<arrgetPost.count)
        {
            var Likecnt = ""
            db.collection(Constants.LikePost)
                .whereField("Postid", isEqualTo: self.arrgetPost[i].PostId!).getDocuments()
            { (querySnapshot, err) in

                if let err = err
                {
                    print("Error getting documents: \(err)")
                }
                else
                {
                    Likecnt = "\(querySnapshot!.documents.count)"
                    self.arrgetPost[i].Like_cnt = Likecnt
                    self.tblView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var cnt = 0
        cnt = self.arrgetPost.count
        return cnt
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "UserProfileCell") as? UserProfileCell
        if cell == nil
        {
            let nib = Bundle.main.loadNibNamed("UserProfileCell", owner: self, options: nil)
            cell = nib?[0] as? UserProfileCell
        }
        
        let obj = self.arrgetPost[indexPath.row]
       
        cell?.postimg.sd_setImage(with: URL(string: obj.Post_img!), placeholderImage: UIImage(named: "icon"))
   
        cell?.lblCaption.text = obj.Caption
        cell?.lblusername.text = self.username
        
        if self.userProfile == ""
        {
            cell?.userprofileimg.image = UIImage.init(named: "no_image")
        }
        else
        {
            cell?.userprofileimg.sd_setImage(with: URL(string: self.userProfile), placeholderImage: UIImage(named: "icon"))
        }
        
        if obj.Like_cnt == "0"
        {
            cell?.lbllike.text = "Like"
        }
        else if obj.Like_cnt == "1"
        {
            cell?.lbllike.text = "\(obj.Like_cnt ?? "") Like"
        }
        else
        {
            cell?.lbllike.text = "\(obj.Like_cnt ?? "") Likes"
        }
        cell?.lbldate.text = obj.Post_date_time
        
        
        if obj.isLikePost == "N"
        {
            cell?.btnlike.setImage(UIImage.init(named:"dislike"), for: .normal)
        }
        else
        {
            cell?.btnlike.setImage(UIImage.init(named:"like"), for: .normal)
        }
        
        cell!.btnlike.tag =  indexPath.row
        cell!.btnlike.addTarget(self, action: #selector(btnLikeAction(sender:)), for: UIControl.Event.touchUpInside)
        
        cell!.btncmt.tag =  indexPath.row
        cell!.btncmt.addTarget(self, action: #selector(btnCmntAction(sender:)), for: UIControl.Event.touchUpInside)
        
        cell?.selectionStyle = .none
        return cell!
    }
    
    @objc func btnLikeAction(sender : Any){
        let btncls = (sender as! UIButton)
        let tag = btncls.tag
        
        if self.arrgetPost[tag].isLikePost == "Y"
        {
            db.collection(Constants.LikePost).whereField("Userid", isEqualTo: GlobalVariables.sharedManager.memberid)
                .whereField("Postid", isEqualTo: self.arrgetPost[tag].PostId!).getDocuments()
            { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else
                {
                    var id = ""
                    for i in querySnapshot!.documents{
                        id = i.documentID
                        self.deleteDocument(Mainclass: Constants.LikePost, subClass: id)
                        self.arrgetPost[tag].isLikePost = "N"
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
            
            let dict = ["Userid": GlobalVariables.sharedManager.memberid, "Postid": self.arrgetPost[tag].PostId!,"date": dateString] as [String : Any]
            
            self.db.collection(Constants.LikePost).addDocument(data: dict) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Post Like")
                }
            }
            self.arrgetPost[tag].isLikePost = "Y"
            self.getLikeCount()
        }
    }
    
    @objc func btnCmntAction(sender : Any){
        let btncls = (sender as! UIButton)
        let tag = btncls.tag
        
        let openview = PostDetailsVC()
        openview.postid = self.arrgetPost[tag].PostId!
        self.push(viewController: openview)
    }
   
    @IBAction func btnBack(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnFollow(sender : UIButton)
    {
        self.FollowFollowing()
    }
    
    func FollowFollowing()
    {
        if self.LoginUserfollow == false
        {
            let date = Date()
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm"
            let dateString = df.string(from: date)
            //self.userid = other user id not a login user id
            let dict = ["Userid": GlobalVariables.sharedManager.memberid, "followingId": self.userid, "Following_Date_time": dateString] as [String : Any]
            
            self.db.collection(Constants.FollowingList).addDocument(data: dict)  { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document successfully written!")

                    self.btnFollow.setTitle("Unfollow", for: .normal)
                    self.btnFollow.backgroundColor = UIColor.clear
                    self.btnFollow.setTitleColor(.black, for: .normal)
                    self.btnFollow.layer.borderWidth = 1
                    self.btnFollow.layer.borderColor = UIColor.black.cgColor
                    self.getFollowFollowingList()
                }
            }
        }
        else
        {
            db.collection(Constants.FollowingList).whereField("Userid", isEqualTo: GlobalVariables.sharedManager.memberid)
                .whereField("followingId", isEqualTo: self.userid).getDocuments()
            { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else
                {
                    var id = ""
                    for i in querySnapshot!.documents{
                        id = i.documentID
                        self.deleteDocument(Mainclass: Constants.FollowingList, subClass: id)
                        self.btnFollow.setTitle("Follow", for: .normal)
                        self.btnFollow.backgroundColor =  UIColor.init(hexString: "#24a0ed")
                        self.btnFollow.setTitleColor(.white, for: .normal)
                        self.btnFollow.layer.borderWidth = 0
                        self.getFollowFollowingList()
                    }
                }
            }
        }
    }
    
    func getFollowFollowingList()
    {
        db.collection(Constants.FollowingList).whereField("Userid", isEqualTo: self.userid).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else
            {
                self.lblFollowingCnt.text = "\(querySnapshot!.documents.count)"
            }
        }
        
        db.collection(Constants.FollowingList).whereField("followingId", isEqualTo: self.userid).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else
            {
                self.lblFollowersCnt.text = "\(querySnapshot!.documents.count)"
            }
        }
        
        //check login user follow to other users
        db.collection(Constants.FollowingList).whereField("Userid", isEqualTo: GlobalVariables.sharedManager.memberid).whereField("followingId", isEqualTo: self.userid).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else
            {
                if querySnapshot!.documents.count != 0
                {
                    self.btnFollow.setTitle("Unfollow", for: .normal)
                    self.btnFollow.backgroundColor = UIColor.clear
                    self.btnFollow.setTitleColor(.black, for: .normal)
                    self.btnFollow.layer.borderWidth = 1
                    self.btnFollow.layer.borderColor = UIColor.black.cgColor
                    self.LoginUserfollow = true
                }
                else
                {
                    self.btnFollow.setTitle("Follow", for: .normal)
                    self.btnFollow.backgroundColor = UIColor.init(hexString: "#24a0ed")
                    self.btnFollow.setTitleColor(.white, for: .normal)
                    self.btnFollow.layer.borderWidth = 0
                    self.btnFollow.layer.borderColor = UIColor.black.cgColor
                    self.LoginUserfollow = false
                }
            }
        }
    }
}
