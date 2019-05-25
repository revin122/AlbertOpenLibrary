//
//  UIViewController.swift
//  OpenLibrary
//
//  Created by Remar Supnet on 5/23/19.
//  Copyright © 2019 Remar Supnet. All rights reserved.
//

import UIKit

extension UIViewController {

    func showMessage(message : String) {
        
        //compute height
        var estimatedHeight : CGFloat = 40
        //create temp label
        let label : UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.height - 100, height: 10))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont(name: "Helvetica", size: 12)
        label.text = message
        label.sizeToFit()
        
        estimatedHeight = estimatedHeight > (label.frame.height + 10) ? estimatedHeight : (label.frame.height + 10)
        
        let messageLabel : UILabel = UILabel(frame: CGRect(x: self.view.frame.size.width / 2 - (self.view.frame.size.width - 50) / 2,
                                                           y: self.view.frame.size.height - 100,
                                                           width: self.view.frame.size.width - 50, height: estimatedHeight))
        messageLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        messageLabel.textColor = UIColor.white
        messageLabel.font = UIFont(name: "Helvetica", size: 12)
        messageLabel.numberOfLines = 0
        messageLabel.text = message
        messageLabel.textAlignment = .center
        messageLabel.alpha = 1.0
        messageLabel.layer.cornerRadius = 10
        messageLabel.clipsToBounds = true
        self.view.addSubview(messageLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            messageLabel.alpha = 0.0
        }, completion: {(completed) in
            messageLabel.removeFromSuperview()
        })
    }
    
}
