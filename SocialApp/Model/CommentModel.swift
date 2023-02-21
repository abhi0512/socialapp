//
//  CommentModel.swift
//  SocialApp
//
//  Created by tis mac on 08/02/23.
//

import Foundation

class CommentModel {
    
    var UserId : String?
    var PostId : String?
    var Username : String?
    var ProfileImg : String?
    var Comment : String?
    var CmntDateTime : String?
    
    init(UserId : String, PostId : String , Username : String, ProfileImg : String , Comment : String, CmntDateTime : String) {
        self.UserId = UserId
        self.PostId = PostId
        self.Username = Username
        self.ProfileImg = ProfileImg
        self.Comment = Comment
        self.CmntDateTime = CmntDateTime
    }
}
