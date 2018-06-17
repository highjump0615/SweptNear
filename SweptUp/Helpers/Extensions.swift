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
        let radius: CGFloat = self.frame.size.height / 2.0
        self.layer.cornerRadius = radius
    }
    
    func makeRoundBorder(width: CGFloat = 1.0, color: UIColor = UIColor.white) {
        makeRound()
        
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
}

extension UIViewController {
    
    func alertOk(title: String, message: String, cancelButton: String, cancelHandler: ((UIAlertAction) -> ())?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: cancelButton, style: .default, handler: cancelHandler)
        
        alertController.addAction(cancelAction)
        
        alertController.view.tintColor = UIColor.darkGray
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showNavbar() {
        self.navigationController?.navigationBar.barTintColor = Constants.gColorTheme
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.font: SHTextHelper.lobster13Regular(size: 20),
            NSAttributedStringKey.foregroundColor: UIColor.white
        ]
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func hideNavbar(animated: Bool = false) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}
