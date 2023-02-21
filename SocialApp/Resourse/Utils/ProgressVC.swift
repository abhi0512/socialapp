//
//  ProgressVC.swift
//  GamesWnted
//
//  Created by Abhishek Rathi on 01/12/20.
//

import Foundation
import UIKit

class ProgressView {

    // MARK: - Variables
    private var containerView = UIView()
    private var progressView = UIView()
    private var activityIndicator = UIActivityIndicatorView()

    static var shared = ProgressView()

    // To close for instantiation
    private init() {}

    // MARK: - Functions
     func startAnimating(view: UIView = (UIApplication.shared.keyWindow?.rootViewController?.view)!) {
        containerView.center = view.center
        containerView.frame = view.frame
        containerView.backgroundColor = UIColor.clear //UIColor(hex: 0xffffff, alpha: 0.75)

        progressView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        progressView.center = containerView.center
        progressView.backgroundColor = UIColor.clear//UIColor(hex: 0x444444, alpha: 0.7)
        progressView.clipsToBounds = true
     
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        activityIndicator.center = CGPoint(x: progressView.bounds.width/2, y: progressView.bounds.height/2)

        if #available(iOS 13.0, *) {
            activityIndicator.style = .medium
        } else {
            // Fallback on earlier versions
        }
        view.addSubview(containerView)
        containerView.addSubview(progressView)
        progressView.addSubview(activityIndicator)

        activityIndicator.startAnimating()
    }

    /// animate UIActivityIndicationView without blocking UI
    func startSmoothAnimation(view: UIView = (UIApplication.shared.keyWindow?.rootViewController?.view)!) {
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        activityIndicator.center = view.center
        if #available(iOS 13.0, *) {
            activityIndicator.style = .medium
        } else {
            // Fallback on earlier versions
        }
        activityIndicator.color = UIColor.white
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }

    func stopAnimatimating() {
        activityIndicator.stopAnimating()
        containerView.removeFromSuperview()
    }

}

extension UIColor {
    convenience init(hex: UInt32, alpha: CGFloat) {
        let red = CGFloat((hex & 0xFF0000) >> 16)/256.0
        let green = CGFloat((hex & 0xFF00) >> 8)/256.0
        let blue = CGFloat(hex & 0xFF)/256.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

