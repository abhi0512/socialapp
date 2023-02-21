//
//  SceneDelegate.swift
//  SocialApp
//
//  Created by tis mac on 31/01/23.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let tabBarController =  UITabBarController()
    var firstVC : UINavigationController!
    var secondVC : UINavigationController!
    var thirdVC : UINavigationController!
    var foruthVC : UINavigationController!
    var fifthVC : UINavigationController!
    var fivethVC : UINavigationController!
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            FirebaseApp.configure()
            let memberid  =  DbHandler.checkuserexist()
            if(memberid != nil && memberid != "")
            {
                let welcome = CheckLoginVC()
                let navcontroller:UINavigationController
                navcontroller =  UINavigationController(rootViewController: welcome)
                window.rootViewController = navcontroller
                self.window = window
                window.makeKeyAndVisible()
            }
            else
            {
                let welcome = LoginVC()
                let navcontroller:UINavigationController
                navcontroller =  UINavigationController(rootViewController: welcome)
                window.rootViewController = navcontroller
                self.window = window
                window.makeKeyAndVisible()
            }
        }
    }
    
    func SetRootControler(){
        
        firstVC = UINavigationController.init(rootViewController:  HomeVC())
        secondVC = UINavigationController.init(rootViewController: SearchVC())
        thirdVC = UINavigationController.init(rootViewController: ExploreVC())
        foruthVC = UINavigationController.init(rootViewController: HistoryVC())
        fivethVC = UINavigationController.init(rootViewController: SettingsVC())
        tabBarController.viewControllers = [firstVC,secondVC,thirdVC,foruthVC, fivethVC]
        
        let  item1 = UITabBarItem(title: "" , image: UIImage(named: "home"), tag: 0)
        let item2 = UITabBarItem(title: "", image: UIImage(named: "Search"), tag: 1)
        let item3 = UITabBarItem(title: "", image: UIImage(named: "explore"), tag: 2)
        let item4 = UITabBarItem(title: "", image: UIImage(named: "heart"), tag: 3)
        let item5 = UITabBarItem(title: "", image: UIImage(named: "setting"), tag: 4)
        
        firstVC.tabBarItem = item1
        secondVC.tabBarItem = item2
        thirdVC.tabBarItem = item3
        foruthVC.tabBarItem = item4
        fivethVC.tabBarItem = item5
     
        tabBarController.selectedIndex = 0
        
        UITabBar.appearance().backgroundColor = .white
        
        UITabBar.appearance().tintColor = UIColor.init(hexString: "#06467A")!
        UITabBar.appearance().unselectedItemTintColor = .gray
        self.window?.rootViewController = tabBarController
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

