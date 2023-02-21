//
//  Location.swift
//  Gypsy
//
//  Created by Abhishek Rathi on 14/01/21.
//  Copyright © 2021 Abhishek Rathi. All rights reserved.
//

import Foundation
import CoreLocation


open class LocationCheck {
        class func isLocationServiceEnabled() -> Bool {
            if CLLocationManager.locationServicesEnabled() {
                switch(CLLocationManager.authorizationStatus()) {
                    case .notDetermined, .restricted, .denied:
                    return false
                    case .authorizedAlways, .authorizedWhenInUse:
                    return true
                    default:
                    print("Something wrong with Location services")
                    return false
                }
            } else {
                    print("Location services are not enabled")
                    return false
              }
            }
         }
