//
//  ViewFollowFollowingListVC.swift
//  SocialApp
//
//  Created by tis mac on 10/02/23.
//

import UIKit
import FirebaseFirestore

class ViewFollowFollowingListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblView : UITableView!
    @IBOutlet weak var NoView : UIView!
    @IBOutlet weak var btnFollowers : UIButton!
    @IBOutlet weak var btnFollowings : UIButton!
    
    let db = Firestore.firestore()
    var tapButton = ""
    var userid = ""
    
    var arrList = [FollowFollowingListModel]()
    var arrListUser = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.SelectButton()
        self.NoView.isHidden = true
        self.tblView.tableFooterView = UIView()
        self.tblView.backgroundColor = UIColor.clear
        self.tblView.separatorStyle = .none
        self.tblView.rowHeight = UITableView.automaticDimension
        self.tblView.estimatedRowHeight = 75
        self.btnFollowers.layer.cornerRadius = 10
        self.btnFollowings.layer.cornerRadius = 10
        // Do any additional setup after loading the view.
    }
    
    func SelectButton()
    {
        // 0 for followers and 1 for following button
        if self.tapButton == "0"
        {
            self.getFollowList()
            self.btnFollowings.isSelected = false
            self.btnFollowings.backgroundColor = .clear
            self.btnFollowings.layer.borderColor = UIColor.gray.cgColor
            self.btnFollowings.layer.borderWidth = 1
            self.btnFollowings.setTitleColor(.black, for: .normal)
            
            self.btnFollowers.isSelected = true
            self.btnFollowers.layer.borderWidth = 0
            self.btnFollowers.backgroundColor = UIColor.init(hexString: "#06467A")
            self.btnFollowers.setTitleColor(.white, for: .normal)

        }
        else
        {
            self.getFollowingList()
            self.btnFollowers.isSelected = false
            self.btnFollowers.layer.borderColor = UIColor.gray.cgColor
            self.btnFollowers.layer.borderWidth = 1
            self.btnFollowers.backgroundColor = .clear
            self.btnFollowers.setTitleColor(.black, for: .normal)
            
            self.btnFollowings.isSelected = true
            self.btnFollowings.layer.borderWidth = 0
            self.btnFollowings.backgroundColor = UIColor.init(hexString: "#06467A")
            self.btnFollowings.setTitleColor(.white, for: .normal)
        }
    }
    
    @IBAction func btnFollowFollowingClick(sender : UIButton)
    {
        if self.tapButton == "0"
        {
            self.tapButton = "1"
        }
        else
        {
            self.tapButton = "0"
        }
        self.SelectButton()
    }
    
    @IBAction func btnBack(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func getFollowList()
    {
        self.arrList.removeAll()
        self.arrListUser.removeAll()
        db.collection(Constants.FollowingList).whereField("followingId", isEqualTo: self.userid).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else
            {
//                if querySnapshot!.documents.count != 0
//                {
//                    self.arrListUser.removeAll()
//                }
                for dict in querySnapshot!.documents {
                    print("\(dict.documentID) => \(dict.data())")
                    self.arrListUser.append((dict["Userid"] as? String)!)
                }
                
                if self.arrListUser.count > 0
                {
                    self.getUserDetails()
                }
                else
                {
                    self.NoView.isHidden = false
                    self.tblView.isHidden = true
                }
            }
        }
    }
    
    func getFollowingList()
    {
        self.arrList.removeAll()
        self.arrListUser.removeAll()
        db.collection(Constants.FollowingList).whereField("Userid", isEqualTo: self.userid).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            else
            {
                for dict in querySnapshot!.documents {
                    print("\(dict.documentID) => \(dict.data())")
                    self.arrListUser.append((dict["Userid"] as? String)!)
                }
                
                if self.arrListUser.count > 0
                {
                    self.getUserDetails()
                }
                else
                {
                    self.NoView.isHidden = false
                    self.tblView.isHidden = true
                }
            }
        }
    }
    
    func getUserDetails()
    {
        self.arrList.removeAll()
        for i in (0..<self.arrListUser.count)
        {
            db.collection(Constants.Social).document(self.arrListUser[i]).addSnapshotListener { (documentSnapshot, err) in
                
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(err!)")
                    return
                }
                
                guard let dict = document.data() else {
                    print("Document data was empty.")
                    return
                }
                
                if document.data()?.count != 0
                {
                    let firstname = dict["firstname"] as? String
                    let lastname = dict["lastname"] as? String
                    let profileimg = dict["Profile_img"] as? String
                    let username = "\(firstname ?? "") \(lastname ?? "")"
                    
                    self.arrList.append(FollowFollowingListModel(profileimage: profileimg!, username: username))
                }
                
                if self.arrList.count > 0
                {
                    self.tblView.isHidden = false
                    self.NoView.isHidden = true
                    self.tblView.reloadData()
                }
                else
                {
                    self.NoView.isHidden = false
                    self.tblView.isHidden = true
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var cnt = 0
        cnt = self.arrList.count
        return cnt
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "FollowFollowingListCell") as? FollowFollowingListCell
        if cell == nil
        {
            let nib = Bundle.main.loadNibNamed("FollowFollowingListCell", owner: self, options: nil)
            cell = nib?[0] as? FollowFollowingListCell
        }
        
        let obj = self.arrList[indexPath.row]
        cell?.lblusername.text = obj.username
        
        if obj.profileimage == ""
        {
            cell?.profileimg.image = UIImage.init(named: "no_image")
        }
        else
        {
            cell?.profileimg.sd_setImage(with: URL(string: obj.profileimage!), placeholderImage: UIImage(named: "icon"))
        }
        cell?.selectionStyle = .none
        
        return cell!
    }
}
