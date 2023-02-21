//
//  UserModel.swift
//  SocialApp
//
//  Created by tis mac on 31/01/23.
//

import Foundation
import UIKit

class UserModel
{
    var Uid : String?
    var firstname : String?
    var lastname : String?
    var email : String?
    var Profile_image : String?
    
    init(Uid : String, firstname : String , lastname : String, email : String , Profile_image : String) {
        self.Uid = Uid
        self.firstname = firstname
        self.lastname = lastname
        self.email = email
        self.Profile_image = Profile_image
    }
}

class EmailModel
{
    var Uid : String?
    var email : String?
    
    init(Uid : String, email : String) {
        self.Uid = Uid
        self.email = email
    }
}
