//
//  CommentVC.swift
//  SocialApp
//
//  Created by tis mac on 13/02/23.
//

import UIKit
import Loaf
import FirebaseFirestore

class CommentVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var commentTblView : UITableView!
    @IBOutlet weak var txtcmt : DesignableUITextField!
    @IBOutlet weak var txtcmtView : UIView!
    @IBOutlet weak var EmptyCmtView : UIView!
    @IBOutlet weak var btncmt : UIButton!
    
    var arrgetPost = [HomePagePostModel]()
    var arrCmnt = [CommentModel]()
    let db = Firestore.firestore()
    var postid = ""
    var userid = ""
    var refreshControl = UIRefreshControl()
    var isrefresh : String = "N"
    var lastindex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.commentTblView.isHidden = true
        self.EmptyCmtView.isHidden = true
        self.commentTblView.tableFooterView = UIView()
        self.commentTblView.separatorStyle = .none
        self.commentTblView.backgroundColor = UIColor.clear
        self.commentTblView.rowHeight = UITableView.automaticDimension
        self.commentTblView.estimatedRowHeight = 75
        self.txtcmtView.layer.shadowOpacity = 0.80
        self.txtcmtView.layer.shadowRadius = 10
        self.txtcmtView.layer.shadowColor = UIColor.init(hexString: "#808080")?.cgColor
        self.txtcmtView.layer.shadowOffset =  CGSize(width: 0, height: 0)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.commentTblView.refreshControl = refreshControl
        
        self.getCmntList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.hideNavigationBar()
        sceneDelegate?.tabBarController.tabBar.isHidden = true
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        // Code to refresh Collection view
        self.isrefresh = "Y"
        self.lastindex = 0
        self.refreshControl.endRefreshing()
        self.getCmntList()
    }

    @IBAction func btnAddCmnt (sender : UIButton)
    {
        if self.txtcmt.text == ""
        {
            let message = "Please add your comment"
            Loaf(message, state: .error, sender: self).show()
        }
        else
        {
            self.AddCmnt()
        }
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
                    self.EmptyCmtView.isHidden = false
                }
                else
                {
                    self.arrCmnt.removeAll()
                    
                    for dict in querySnapshot!.documents {
                        print("\(dict.documentID) => \(dict.data())")
                        
                        let cmntuserID = dict["Userid"] as? String
                        let cmntPostid = dict["Postid"] as? String
                        let cmntusername = dict["Username"] as? String
                        let cmntdateTime = dict["dateTime"] as? String
                        let Comment = dict["Comment"] as? String
                        let cmntProfileImg = dict["ProfileImg"] as? String
                        
                        self.arrCmnt.append(CommentModel(UserId: cmntuserID!, PostId: cmntPostid!, Username: cmntusername!, ProfileImg: cmntProfileImg!, Comment: Comment!, CmntDateTime: cmntdateTime!))
                        self.txtcmt.text = ""
                    }
                    
                    if self.arrCmnt.count > 0
                    {
                        if(self.isrefresh == "Y")
                        {
                            self.isrefresh = "N"
                            self.refreshControl.endRefreshing()
                        }
                        self.lastindex = self.arrCmnt.count
                        self.commentTblView.isHidden = false
                        self.EmptyCmtView.isHidden = true
                        self.commentTblView.reloadData()
                    }
                    else
                    {
                        self.commentTblView.isHidden = true
                        self.EmptyCmtView.isHidden = false
                    }
                }
            }
        }
        self.commentTblView.isHidden = true
        self.EmptyCmtView.isHidden = true
    }
    
    func AddCmnt()
    {
        let date = Date()
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = df.string(from: date)
        
        var username = ""
        var profileimg = ""
        var userdata = NSMutableArray()
        userdata = DbHandler.fetchuserdetail()
        if(userdata.count > 0)
        {
            let fname = ((userdata[0] as AnyObject).value(forKey: "firstname") as? String)!
            let lname = ((userdata[0] as AnyObject).value(forKey: "lastname") as? String)!

            username = "\(fname) \(lname)"
            profileimg = ((userdata[0] as AnyObject).value(forKey: "profileimage") as? String)!
        }
        
        let dict = ["Comment": self.txtcmt.text!, "dateTime": dateString, "Userid": GlobalVariables.sharedManager.memberid , "Username" : username, "ProfileImg" : profileimg, "Postid": self.postid]
        
        self.db.collection(Constants.PostComment).addDocument(data: dict) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                self.getCmntList()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var cnt = 0
        cnt = self.arrCmnt.count
        return cnt
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as? CommentCell
        if cell == nil
        {
            let nib = Bundle.main.loadNibNamed("CommentCell", owner: self, options: nil)
            cell = nib?[0] as? CommentCell
        }
        
        let obj = self.arrCmnt[indexPath.row]
        
        let attrs1 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor : UIColor.black]

        let attrs2 = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor : UIColor.gray]

        let name = obj.Username ?? ""
        let datetime = obj.CmntDateTime ?? ""
        let attributedString1 = NSMutableAttributedString(string:name, attributes:attrs1)

        let attributedString2 = NSMutableAttributedString(string:" \(datetime)", attributes:attrs2)

        attributedString1.append(attributedString2)
        
        cell?.lblComment.text = obj.Comment
        cell?.lblCmntUserName.attributedText = attributedString1
        if obj.ProfileImg == ""
        {
            cell?.profile_img.image = UIImage.init(named: "no_image")
        }
        else
        {
        cell?.profile_img.sd_setImage(with: URL(string: obj.ProfileImg!), placeholderImage: UIImage(named: "icon"))
        }
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            
            let obj = self.arrCmnt[indexPath.row]
            self.deleteComment(userid: obj.UserId!, postid: obj.PostId!, comment: obj.Comment!)
            self.arrCmnt.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func deleteComment(userid : String, postid : String, comment : String)
    {
        db.collection(Constants.PostComment).whereField("Userid", isEqualTo: userid)
            .whereField("Postid", isEqualTo: postid).whereField("Comment", isEqualTo: comment).getDocuments()
        { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else
            {
                var id = ""
                for i in querySnapshot!.documents{
                    id = i.documentID
                    self.deleteDocument(Mainclass: Constants.PostComment, subClass: id)
                    self.commentTblView.reloadData()
                }
            }
        }
    }

    @IBAction func btnBack(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
}
