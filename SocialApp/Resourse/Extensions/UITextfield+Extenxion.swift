//
//  UITextfield+Extenxion.swift
//  PatientCareServices
//
//  Created by SID on 30/10/21.
//

import Foundation
import UIKit

extension UITextField {

   func addInputViewDatePicker(target: Any, selector: Selector) {

    let screenWidth = UIScreen.main.bounds.width

    //Add DatePicker as inputView
    let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
       if #available(iOS 13.4, *) {
           if #available(iOS 14.0, *) {
               datePicker.preferredDatePickerStyle = .inline
           } else {
               // Fallback on earlier versions
           }       } else {
           print("This app is not available for this phone ")
       }
       datePicker.datePickerMode = .date
    self.inputView = datePicker

    //Add Tool Bar as input AccessoryView
    let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
    let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPressed))
    let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
    toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)

    self.inputAccessoryView = toolBar
 }

   @objc func cancelPressed() {
     self.resignFirstResponder()
   }
    
//    timepicker
    func addInputViewTimePicker(target: Any, selector: Selector) {

     let screenWidth = UIScreen.main.bounds.width

     //Add DatePicker as inputView
     let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        if #available(iOS 13.4, *) {
            if #available(iOS 14.0, *) {
                datePicker.preferredDatePickerStyle = .wheels
//                datePicker.locale = Locale.init(identifier: "en_us") 

            } else {
                // Fallback on earlier versions
            }       } else {
            print("This app is not available for this phone ")
        }
        datePicker.datePickerMode = .time
     self.inputView = datePicker

     //Add Tool Bar as input AccessoryView
     let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
     let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
     let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(canceltimePressed))
     let doneBarButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
     toolBar.setItems([cancelBarButton, flexibleSpace, doneBarButton], animated: false)

     self.inputAccessoryView = toolBar
  }

    @objc func canceltimePressed() {
      self.resignFirstResponder()
    }
}

//extension Date {
//    func string(format: String) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = format
//        return formatter.string(from: self)
//    }
//    func timestring(format: String) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = format
//        return formatter.string(from: self)
//    }
//    
//}
