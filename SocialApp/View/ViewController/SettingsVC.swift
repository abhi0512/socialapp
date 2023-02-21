//
//  SettingsVC.swift
//  SocialApp
//
//  Created by tis mac on 01/02/23.
//

import UIKit

class SettingsVC: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var userimg: UIImageView!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lblemail: UILabel!
    var arrSetting = [["title" : "My Profile" ,"img" : "myprofile"],
                      ["title" : "Change Password" ,"img" : "chnagepassword"],
                      ["title" : "My Post" ,"img" : "createpost"],
                      ["title" : "Logout" ,"img" : "logout"]
                      ]

    override func viewDidLoad() {
        self.FetchUserDetails()
        self.userimg.layer.cornerRadius = (self.userimg.frame.height) / 2
        self.tblView.tableFooterView = UIView()
        self.tblView.backgroundColor = UIColor.clear
        self.tblView.rowHeight = UITableView.automaticDimension
        self.tblView.estimatedRowHeight = 75
        self.tblView.reloadData()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.hideNavigationBar()
        sceneDelegate?.tabBarController.tabBar.isHidden = false
    }
    
    func FetchUserDetails()
    {
        var userdata = NSMutableArray()
        userdata = DbHandler.fetchuserdetail()
        if(userdata.count > 0)
        {
            let fname = ((userdata[0] as AnyObject).value(forKey: "firstname") as? String)!
            let lname = ((userdata[0] as AnyObject).value(forKey: "lastname") as? String)!
            self.lblname.text = "\(fname) \(lname)"
            self.lblemail.text = ((userdata[0] as AnyObject).value(forKey: "email") as? String)!
            let img = ((userdata[0] as AnyObject).value(forKey: "profileimage") as? String)!
            
            if img != ""
            {
                self.userimg.sd_setImage(with: URL(string: img), placeholderImage: UIImage(named: "icon"))
            }
            else
            {
                self.userimg.image = UIImage.init(named: "no_image")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var cnt = 0
        cnt = self.arrSetting.count
        return cnt
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell") as? SettingCell
        if cell == nil
        {
            let nib = Bundle.main.loadNibNamed("SettingCell", owner: self, options: nil)
            cell = nib?[0] as? SettingCell
        }
        
        let obj = self.arrSetting[indexPath.row]
        
        cell?.img_icon.image = UIImage.init(named: obj["img"]!)
        cell?.lbltitle.text = obj["title"]
        cell?.selectionStyle = .none
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0
        {
            let openview = EditProfileVC()
            self.push(viewController: openview)
        }
        else if indexPath.row == 1
        {
            let openview = ChangePasswordVC()
            self.push(viewController: openview)
        }
        else if indexPath.row == 2
        {
            let openview = MyPostVC()
            self.push(viewController: openview)
        }
        else
        {
            DbHandler.deleteDatafromtable("delete from tbluser")
            GlobalVariables.sharedManager.memberid = ""
            let openview = LoginVC()
            self.push(viewController: openview)
        }
    }
}
