//
//  ProfilePopupReport.swift
//  SweptUp
//
//  Created by Administrator on 7/12/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit
import KMPlaceholderTextView

class ProfilePopupReport: BaseCustomView {
    
    @IBOutlet weak var mTextViewDesc: KMPlaceholderTextView!
    @IBOutlet weak var mButReport: UIButton!
    
    var mUser: User? = nil
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    static func getView(user: User?) -> UIView {
        let view = super.getView(nibName: "ProfilePopupReport") as! ProfilePopupReport
        view.mUser = user
        
        return view
    }
    
    override func showView(bShow: Bool, animated: Bool) {
        super.showView(bShow: bShow, animated: animated)
        
        // clear text
        mTextViewDesc.text = ""
    }
    
    @IBAction func onButClose(_ sender: Any) {
        self.showView(bShow: false, animated: true)
        
        // hide keyboard
        mTextViewDesc.resignFirstResponder()
    }

    @IBAction func onButReport(_ sender: Any) {
        let userCurrent = User.currentUser!
        
        if !mTextViewDesc.text.isEmpty {
            //
            // create & save report
            //
            let reportNew = Report()
            reportNew.senderId = userCurrent.id
            reportNew.sender = userCurrent
            reportNew.description = mTextViewDesc.text
            
            reportNew.saveToDatabase(withID: nil, parentID: mUser?.id)
        }
        
        // close popup
        onButClose(sender)
    }
}
