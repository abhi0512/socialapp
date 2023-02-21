//
//  HomePagePost.swift
//  SocialApp
//
//  Created by tis mac on 04/02/23.
//

import Foundation
import UIKit

class HomePagePostModel
{
    var UserId : String?
    var PostId : String?
    var Caption : String?
    var Post_date_time : String?
    var Post_img : String?
    var Username : String?
    var Profile_img : String?
    var Like_cnt : String?
    var isLikePost : String?
    
    init(UserId : String, PostId : String , Caption : String, Post_date_time : String , Post_img : String, Username : String, Profile_img : String, Like_cnt : String, isLikePost : String) {
        self.UserId = UserId
        self.PostId = PostId
        self.Caption = Caption
        self.Post_date_time = Post_date_time
        self.Post_img = Post_img
        self.Username = Username
        self.Profile_img = Profile_img
        self.Like_cnt = Like_cnt
        self.isLikePost = isLikePost
    }
}

class UserProfileModel
{
    var UserId : String?
    var PostId : String?
    var Caption : String?
    var Post_date_time : String?
    var Post_img : String?
    var Like_cnt : String?
    var isLikePost : String?
    
    init(UserId : String, PostId : String , Caption : String, Post_date_time : String , Post_img : String, Like_cnt : String, isLikePost : String) {
        self.UserId = UserId
        self.PostId = PostId
        self.Caption = Caption
        self.Post_date_time = Post_date_time
        self.Post_img = Post_img
        self.Like_cnt = Like_cnt
        self.isLikePost = isLikePost
    }
}
