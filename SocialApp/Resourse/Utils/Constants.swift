//
//  Constants.swift
//  Aeryus
//
//  Created by Wang Gang on 9/12/18.
//  Copyright © 2018 Aeryus. All rights reserved.
//

import UIKit

let ScreenWidth = UIScreen.main.bounds.width
let ScreenHeight = UIScreen.main.bounds.height
@available(iOS 13.0, *)
let appdelegate = UIApplication.shared.delegate as! AppDelegate
@available(iOS 13.0, *)
let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
@available(iOS 13.0, *)
let IsIPhoneX = UIScreen.main.nativeBounds.height == 2436
let ScreenRatio = ScreenWidth / 375


class Constants {
    
//    //debug
//    #if DEBUG
//           static let baseUrl = "http://www.produit.in/Demo/411/api/"
//       #else
//            static let baseUrl = "http://www.produit.in/Demo/411/api/"
//       #endif
    
    //live
    
 
    #if DEBUG
           static let baseUrl = "http://mindzsoft.com/demo/homebrewclub/api/"
       #else
            static let baseUrl = "http://mindzsoft.com/demo/homebrewclub/api/"
       #endif
    
    @available(iOS 13.0, *)
    public static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let devicetype = "I"
    static let pagerecordsize = 10
    static let errorcolorcode = "#FF0000"
    static let screenSize = UIScreen.main.bounds
    static let screenWidth = screenSize.width
    static let screenHeight = screenSize.height
   
   
    static let appname  = "Social App"
    static let Social  = "Social"
    static let UserPost  = "User_Post"
    static let LikePost  = "Like_Post"
    static let PostComment  = "Post_Comment"
    static let FollowingList  = "Following_List"
    
    static var orderid = ""
    static var ordertype = ""
//    static let appicon  = UIImage.init(named: "app_icon")
    static var lang  = ""
    
    static let dateformat  = "yyyy-MM-dd HH:mm:ss"
    static let onlinecolor  = "#93FF00"
    static let offlinecolor  = "#999999"
    static let notificationreadcolor  = "#607D8B"
    static let notificatiounreadcolor = "#ffffff"
    static let nonetwork = "No network"
    static let apicode = "df78b37fc48760bee44c28df9c716a26"
    static let headerkey = "API-TOKEN"
    static let headervalue = "A?DG+KbPeShVmYq3t6w9z$C&EH@McQfTjWnZr4u7x!A%D*G-JaNdRgUkXp2s5v"
    static let headerkey1 = "Y-AUTH-TOKEN"
    static let SignUpLink = "http://mindzsoft.com/demo/homebrewclub/register"
    static let AlertMessage = "To access please login or signup."
    static var InstaLink = ""
    static var TwitterLink = ""
    static var TittokLink = ""
    static var HomeBrewUrl = "http://mindzsoft.com/demo/homebrewclub/login"
    
    public static let NetworkUnavailable = "Aah! Looks like you in remote location No Internet connection"
    static let safeareabottomheight  = 84
    
    static let isSimulator: Bool = {
        var isSim = false
    #if arch(i386) || arch(x86_64)
        isSim = true
    #endif
        return isSim
    }()
    
    static var VibrateisOn = "N"
    
    static let navBarHeight: CGFloat = 44
    static let statusBarHeight: CGFloat = 20
    
    static let SideMenuWidth: CGFloat = ScreenWidth * 0.8
    
    static var selectedmenuindex = -1 
    
    struct CreatePostPop
    {
        static var isok = "N"
    }
}
