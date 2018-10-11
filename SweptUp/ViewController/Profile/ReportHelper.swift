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
    var user: User?
    
    init(user: User?, delegate: ReportHelperDelegate) {
        self.delegate = delegate
        self.vc = delegate.getViewController()
        self.user = user
        
        mViewReport = ProfilePopupReport.getView(user: user) as? ProfilePopupReport
        self.vc.view.addSubview(mViewReport!)
    }
    
    func showMenuDialog() {
        let userCurrent = User.currentUser!
        let titleBlock = userCurrent.isBlockedUser(user!.id) ? "Unblock User" : "Block User"
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        alert.addAction(UIAlertAction(title: "Report User", style: .default, handler: { (action) in
            // show report view
            self.mViewReport?.frame = self.vc.view.bounds
            self.mViewReport?.showView(bShow: true, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: titleBlock, style: .default, handler: { (action) in
            userCurrent.blockUser(self.user?.id)
            
            // show toast
            if userCurrent.isBlockedUser(self.user!.id) {
                self.vc.view.makeToast("Blocked this user successfully")
            }
            else {
                self.vc.view.makeToast("Unblocked this user successfully")
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.vc.present(alert, animated: true, completion: nil)
    }
    
}
