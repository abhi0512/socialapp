//
//  PostModel.swift
//  SocialApp
//
//  Created by tis mac on 04/02/23.
//

import Foundation
import UIKit

class PostModel
{
    var UserId : String?
    var PostId : String?
    var Caption : String?
    var Post_date_time : String?
    var Post_img : String?
    
    init(UserId : String, PostId : String , Caption : String, Post_date_time : String , Post_img : String) {
        self.UserId = UserId
        self.PostId = PostId
        self.Caption = Caption
        self.Post_date_time = Post_date_time
        self.Post_img = Post_img
    }
}
