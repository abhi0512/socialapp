//
//  SettingCell.swift
//  SocialApp
//
//  Created by tis mac on 03/02/23.
//

import UIKit

class SettingCell: UITableViewCell {

    @IBOutlet weak var img_icon : UIImageView!
    @IBOutlet weak var lbltitle : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
