//
//  File.swift
//  SweptUp
//
//  Created by Administrator on 10/10/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import Foundation
import UIKit
import Toast_Swift

protocol ReportHelperDelegate {
    func getViewController() -> UIViewController
}


class ReportHelper {
    
    var delegate: ReportHelperDelegate
    var vc: UIViewController
    
    var mViewReport: ProfilePopupReport?
    
    init(user: User?, delegate: ReportHelperDelegate) {
        self.delegate = delegate
        self.vc = delegate.getViewController()
        
        mViewReport = ProfilePopupReport.getView(user: user) as? ProfilePopupReport
        self.vc.view.addSubview(mViewReport!)
    }
    
    func showMenuDialog() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        alert.addAction(UIAlertAction(title: "Report User", style: .default, handler: { (action) in
            // show report view
            self.mViewReport?.frame = self.vc.view.bounds
            self.mViewReport?.showView(bShow: true, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Block User", style: .default, handler: { (action) in
            
            // show toast
            self.vc.view.makeToast("Blocked this user successfully")
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.vc.present(alert, animated: true, completion: nil)
    }
    
}
