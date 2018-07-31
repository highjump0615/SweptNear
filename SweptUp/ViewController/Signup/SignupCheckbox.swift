//
//  SignupCheckbox.swift
//  SweptUp
//
//  Created by Administrator on 6/23/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit

class SignupCheckbox: UIStackView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    func setEnabled(enabled: Bool) {
        // tick image view
        let viewImg = arrangedSubviews[0] as? UIImageView
        if enabled {
            // green tickmark
            viewImg?.tintColor = UIColor(red: 157/255.0, green: 226/255.0, blue: 115/255.0, alpha: 1.0)
        }
        else {
            // gray tickmark
            viewImg?.tintColor = UIColor(red: 134/255.0, green: 132/255.0, blue: 133/255.0, alpha: 1.0)
        }

        let viewLabel = arrangedSubviews[1] as? UILabel
        viewLabel?.alpha = enabled ? 1 : 0.55
    }
}
