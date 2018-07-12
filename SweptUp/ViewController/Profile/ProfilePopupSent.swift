//
//  ProfilePopupSent.swift
//  SweptUp
//
//  Created by Administrator on 6/21/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit

class ProfilePopupSent: BaseCustomView {

    @IBOutlet weak var mViewWink: UIView!
    @IBOutlet weak var mViewMain: UIView!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    static func getView() -> UIView {
        return super.getView(nibName: "ProfilePopupSent")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        mViewMain.layer.masksToBounds = true
        mViewMain.layer.cornerRadius = 5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mViewWink.makeRound()
    }
    
    @IBAction func onButClose(_ sender: Any) {
        self.showView(bShow: false, animated: true)
    }
    
}
