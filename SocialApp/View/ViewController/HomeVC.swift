//
//  HomeVC.swift
//  SocialApp
//
//  Created by tis mac on 01/02/23.
//

import UIKit
import FittedSheets
import MaryPopin
import FirebaseFirestore
import FirebaseStorage

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource , UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    var ImagePicker = UIImagePickerController()
    let db = Firestore.firestore()
    @IBOutlet weak var postTblView: UITableView!
    
    var arrPost = [PostModel]()
    var arrUser = [UserModel]()
    var arrgetPost = [HomePagePostModel]()
    var Likecnt = ""
    var lastindex = 0
    
    var refreshControl = UIRefreshControl()
    var isrefresh : String = "N"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserPost()
        self.postTblView.tableFooterView = UIView()
        self.postTblView.backgroundColor = UIColor.clear
        self.postTblView.separatorStyle = .none
        self.postTblView.rowHeight = UITableView.automaticDimension
        self.postTblView.estimatedRowHeight = 75
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.postTblView.refreshControl = refreshControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.hideNavigationBar()
        sceneDelegate?.tabBarController.tabBar.isHidden = false
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        // Code to refresh Collection view
        self.isrefresh = "Y"
        self.lastindex = 0
        self.refreshControl.endRefreshing()
        self.getUserPost()
    }
    
    func getUserPost()
    {
        db.collection(Constants.UserPost).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.arrPost.removeAll()
                for dict in querySnapshot!.documents {
                    
                    let postID = dict.documentID
                    let Userid = dict["Userid"] as? String
                    let Caption = dict["Caption"] as? String
                    let Post_date_time = dict["Post_date_time"] as? String
                    let Post_img = dict["Post_img"] as? String
                    
                    self.arrPost.append(PostModel(UserId: Userid!, PostId: postID, Caption: Caption!, Post_date_time: Post_date_time!, Post_img: Post_img!))
                }
                
                self.getPostLike()
            }
        }
    }
    
    func getPostLike()
    {
        self.arrgetPost.removeAll()
        for i in (0..<self.arrPost.count)
        {
            db.collection(Constants.LikePost).whereField("Userid", isEqualTo: GlobalVariables.sharedManager.memberid)
            .whereField("Postid", isEqualTo: self.arrPost[i].PostId!).getDocuments()
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
                self.getUserDetails(PostIndex: i, postlikr: postlikr)
            }
        }
    }
    
    func getUserDetails(PostIndex : Int , postlikr : String )
    {
        db.collection(Constants.Social).document(self.arrPost[PostIndex].UserId!).addSnapshotListener { (documentSnapshot, err) in
            
            guard let document = documentSnapshot else {
                print("Error fetching document: \(err!)")
                return
            }
            
            guard let dict = document.data() else {
                print("Document data was empty.")
                return
            }
            
            if self.lastindex == 0
            {
                self.arrgetPost.removeAll()
            }
            
            let obj = self.arrPost[PostIndex]
            
            let firstname = dict["firstname"] as? String
            let lastname = dict["lastname"] as? String
            let profile_img = dict["Profile_img"] as? String
            let username = "\(firstname ?? "") \(lastname ?? "")"
            
            self.arrgetPost.append(HomePagePostModel(UserId: obj.UserId!, PostId: obj.PostId! , Caption: obj.Caption!, Post_date_time: obj.Post_date_time!, Post_img: obj.Post_img!, Username: username, Profile_img: profile_img!, Like_cnt:  "", isLikePost: postlikr))
            
            if self.arrgetPost.count > 0
            {
                if(self.isrefresh == "Y")
                {
                    self.isrefresh = "N"
                    self.refreshControl.endRefreshing()
                }
                self.lastindex = self.arrgetPost.count
                self.getLikeCount()
                self.postTblView.reloadData()
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
                    self.postTblView.reloadData()
                }
            }
        }
    }
    
    @IBAction func btnCreatePost(sender : UIButton)
    {
        self.createpost()
    }
    
    func createpost()
    {
        let openView = CreatePostVC()
        let sheetview = SheetViewController(
            controller: openView,
            sizes: [.fixed(CGFloat(200))], options: SheetOptions(shrinkPresentingViewController: true))
        sheetview.didDismiss = { _ in
            if Constants.CreatePostPop.isok == "Y"
            {
                Constants.CreatePostPop.isok = "N"
                self.UplodeImage()
            }
        }
        sheetview.allowPullingPastMaxHeight = false
        self.present(sheetview, animated: true, completion: nil)
    }
    
    
    func UplodeImage()
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
        dismiss(animated: true, completion: nil)
        let openview = PostVC()
        openview.selectedimage = image!
        self.push(viewController: openview)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var cnt = 0
        cnt = self.arrgetPost.count
        return cnt
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "HomePostCell") as? HomePostCell
        if cell == nil
        {
            let nib = Bundle.main.loadNibNamed("HomePostCell", owner: self, options: nil)
            cell = nib?[0] as? HomePostCell
        }
        
        let obj = self.arrgetPost[indexPath.row]
        
        if obj.Profile_img == ""
        {
            cell?.userprofileimg.image = UIImage.init(named: "no_image")
        }
        else
        {
            cell?.userprofileimg.sd_setImage(with: URL(string: obj.Profile_img!), placeholderImage: UIImage(named: "icon"))
        }
        cell?.postimg.sd_setImage(with: URL(string: obj.Post_img!), placeholderImage: UIImage(named: "icon"))
        cell?.lblusername.text = obj.Username
        cell?.lblusername.tag = indexPath.row
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.lblclick))
        cell!.lblusername.isUserInteractionEnabled = true
        cell!.lblusername.addGestureRecognizer(gesture)
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let openview = PostDetailsVC()
        openview.postid = self.arrgetPost[indexPath.row].PostId!
        self.push(viewController: openview)
    }
    
    @objc func lblclick(sender : UITapGestureRecognizer)
    {
        let position = sender.location(in: self.postTblView)
        guard let index = self.postTblView.indexPathForRow(at: position) else {
            print("Error label not in tableView")
            return
        }

        let openview = ViewUserProfileVC()
        openview.userid = self.arrgetPost[index.row].UserId!
        self.push(viewController: openview)
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
        
        let openview = CommentVC()
        openview.postid = self.arrgetPost[tag].PostId!
        self.push(viewController: openview)
    }
}
