//
//  Extensions.swift
//  SweptUp
//
//  Created by Administrator on 6/12/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import Foundation
import UIKit


extension UIApplication {
    
    /// For setting background color of status bar
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

extension UIView {
    
    /// fille round
    func makeRound() {
        let radius: CGFloat = self.bounds.size.height / 2.0
        self.layer.cornerRadius = radius
    }
    
    func makeRoundBorder(width: CGFloat = 1.0, color: UIColor = UIColor.white) {
        makeRound()
        
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
}
