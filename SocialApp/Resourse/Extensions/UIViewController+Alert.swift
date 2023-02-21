//
//  UIViewController+Alert.swift
//  Aeryus
//
//  Created by Wang Gang on 9/12/18.
//  Copyright © 2018 Aeryus. All rights reserved.
//

import UIKit

extension UIViewController {
    
    //MARK: - Show alert messages
    func showAlert(message: String, okButtonHandler: ((UIAlertAction) -> Void)? = nil) {
        showAlert(title: StringTable.TAG, message: message, okButtonHandler)
    }
    
    func showAlert(title: String, message: String, _ okButtonHandler: ((UIAlertAction) -> Void)? = nil) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: okButtonHandler))
        DispatchQueue.main.async {
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    func showErrorMessage(error: NSError?) {
        let title = error?.userInfo["__type"] as? String
        let message = error?.userInfo["message"] as? String
        if title == nil && message == nil {
            self.showServerErrorMessage()
        } else {
            self.showAlert(title: title!, message: message!)
        }
    }
    
    func showServerErrorMessage() {
        showAlert(title: StringTable.CONN_ERROR_TAG, message: StringTable.CONN_ERROR_MESSAGE)
    }
}
