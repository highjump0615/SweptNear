//
//  AdminUserCell.swift
//  SweptUp
//
//  Created by Administrator on 7/30/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit

class AdminUserCell: UITableViewCell {
    
    @IBOutlet weak var mLblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func fillContent(user: User) {
        mLblTitle.text = user.userFullName()
    }
}
