//
//  FollowFollowingListCell.swift
//  SocialApp
//
//  Created by tis mac on 11/02/23.
//

import UIKit

class FollowFollowingListCell: UITableViewCell {

    @IBOutlet weak var profileimg : UIImageView!
    {
        didSet
        {
            profileimg.layer.cornerRadius = (profileimg.frame.height) / 2 
        }
    }
    @IBOutlet weak var lblusername : UILabel!
    @IBOutlet weak var btnfollow : UIButton!
    {
        didSet
        {
            btnfollow.layer.cornerRadius = 10
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
