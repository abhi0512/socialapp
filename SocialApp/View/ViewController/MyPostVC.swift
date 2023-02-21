//
//  MyPostVC.swift
//  SocialApp
//
//  Created by tis mac on 04/02/23.
//

import UIKit
import FirebaseFirestore

class MyPostVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var postCltView : UICollectionView!
    var arrPost = [PostModel]()
    let db = Firestore.firestore()
    let cellIdentifier = "cellIdentifier"
    
    override func viewDidLoad() { 
        super.viewDidLoad()
        self.getUserPost()
        self.postCltView.register(UINib(nibName: "MyPostCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        // Do any additional setup after loading the view.
    }


    
    func getUserPost()
    {
        db.collection(Constants.UserPost).whereField("Userid", isEqualTo: GlobalVariables.sharedManager.memberid).getDocuments() { (querySnapshot, err) in
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
                    
                    if Userid == GlobalVariables.sharedManager.memberid
                    {
                        self.arrPost.append(PostModel(UserId: Userid!, PostId: postID, Caption: Caption!, Post_date_time: Post_date_time!, Post_img: Post_img!))
                    }
                    
                    if self.arrPost.count > 0
                    {
                        self.postCltView.reloadData()
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var cnt = 0
        cnt = self.arrPost.count
        return cnt
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath as IndexPath) as! MyPostCell
        let obj = arrPost[indexPath.row]
        
        cell.PostsImage.sd_addActivityIndicator()
        cell.PostsImage.sd_setImage(with: URL(string: obj.Post_img!), placeholderImage: UIImage(named: "icon"))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let obj = self.arrPost[indexPath.row]
        self.deleteDocument(Mainclass: "User_Post", subClass: obj.PostId!)
        self.arrPost.remove(at: indexPath.row)
        self.postCltView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let wh = ScreenWidth
        return CGSize(width: wh/2, height: wh/2)
    }
    
    
    @IBAction func btnBack(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
}
