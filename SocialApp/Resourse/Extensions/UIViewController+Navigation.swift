//
//  UIViewController+Navigation.swift
//  Aeryus
//
//  Created by Wang Gang on 9/12/18.
//  Copyright © 2018 Aeryus. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseStorage


let BlurEffectViewTag = 9900
let db = Firestore.firestore()
extension UIViewController {
    
    /**
     If current UIViewController is root view controller, dismiss UINavigationController.
     Otherwise, pop current UIViewController.
     */
    func dismissViewController(animated: Bool) {
        DispatchQueue.main.async {
            let vcArray = self.navigationController?.viewControllers
            if vcArray?.count == 1 {
                self.navigationController?.dismiss(animated: animated, completion: nil)
            } else {
                self.navigationController?.popViewController(animated: animated)
            }
        }
    }
    
    //MARK: - Navigation functions
    func popAndPushViewController(vc: UIViewController, animated: Bool) {
        DispatchQueue.main.async {
            var vcArray = self.navigationController?.viewControllers
            vcArray!.removeLast()
            vcArray!.append(vc)
            self.navigationController?.setViewControllers(vcArray!, animated: animated)
        }
    }
    
    func presentNavController(rootVC: UIViewController) {
        DispatchQueue.main.async {
            let nvc = UINavigationController(rootViewController: rootVC)
            nvc.navigationBar.isHidden = true
            self.navigationController?.present(nvc, animated: true, completion: nil)
        }
    }
    
    func pushtobottom(viewController: UIViewController, animated: Bool = true) {
           DispatchQueue.main.async {
               
               let transition = CATransition()
               transition.duration = 0.2
               transition.type = CATransitionType.push
               transition.subtype = CATransitionSubtype.fromTop
               transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
               self.navigationController?.view.layer.add(transition, forKey: kCATransition)
               self.navigationController?.pushViewController(viewController, animated: false)
           }
       }
       
    
    
    func pushtoleft(viewController: UIViewController, animated: Bool = true) {
        DispatchQueue.main.async {
            
            let transition = CATransition()
            transition.duration = 0.2
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromLeft
            transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
            self.navigationController?.view.layer.add(transition, forKey: kCATransition)
            self.navigationController?.pushViewController(viewController, animated: false)
        }
    }
    
    func push(viewController: UIViewController, animated: Bool = true) {
        DispatchQueue.main.async {
    
            let transition = CATransition()
            transition.duration = 0.2
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
            self.navigationController?.view.layer.add(transition, forKey: kCATransition)
            self.navigationController?.pushViewController(viewController, animated: false)
        }
    }
    
    /** Hide navigation bar */
    func hideNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func showBlurView() {
        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        blurEffectView.tag = BlurEffectViewTag
        view.addSubview(blurEffectView)
        blurEffectView.frame = view.bounds
        blurEffectView.alpha = 0.0
        
        UIView.animate(withDuration: 0.4, delay: 0, options: [.curveLinear], animations: {
            blurEffectView.alpha = 1.0
        })
    }
    
    func hideBlurView() {
        if let blurView = view.viewWithTag(BlurEffectViewTag) {
            blurView.removeFromSuperview()
        }
    }
    
    
    func deleteDocument(Mainclass: String , subClass : String) {
            // [START delete_document]
//        SYioYCB9Xws5NZ1MOfK9
            db.collection(Mainclass).document(subClass).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
            // [END delete_document]
        }
}
