//
//  BaseCustomView.swift
//  SweptUp
//
//  Created by Administrator on 6/21/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit

class BaseCustomView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    static func getView(nibName: String) -> UIView {
        let nib = Bundle.main.loadNibNamed(nibName, owner: self, options: nil)
        let view = nib?[0] as? UIView
        
        return view!
    }

}
