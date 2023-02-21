//
//  HomePostCell.swift
//  SocialApp
//
//  Created by tis mac on 03/02/23.
//

import UIKit

class HomePostCell: UITableViewCell {

    @IBOutlet weak var userprofileimg : UIImageView!
    {
        didSet
        {
            userprofileimg.layer.cornerRadius = (userprofileimg.frame.height) / 2
        }
    }
    
    @IBOutlet weak var postimg : UIImageView!
    @IBOutlet weak var lblusername : UILabel!
    @IBOutlet weak var btnmenu : UIButton!
    @IBOutlet weak var btnlike : UIButton!
    @IBOutlet weak var btncmt : UIButton!
    @IBOutlet weak var btnShare : UIButton!
    @IBOutlet weak var lbllike : UILabel!
    @IBOutlet weak var lbldate : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
