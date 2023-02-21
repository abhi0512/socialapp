//
//  CommentCell.swift
//  SocialApp
//
//  Created by tis mac on 08/02/23.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var mainview : UIView!
    {
        didSet
        {
            mainview.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var profile_img : UIImageView!
    {
        didSet
        {
            profile_img.layer.cornerRadius = (profile_img.frame.height) / 2
        }
    }
    @IBOutlet weak var lblCmntUserName : UILabel!
    @IBOutlet weak var lblComment : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
