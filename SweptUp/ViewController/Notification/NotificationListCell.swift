//
//  NotificationListCell.swift
//  SweptUp
//
//  Created by Administrator on 6/18/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit

class NotificationListCell: UITableViewCell {

    @IBOutlet weak var mImgViewIcon: UIImageView!
    @IBOutlet weak var mLblNotice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func fillContent(data: Notification) {
        switch data.type {
        case Notification.TYPE_WINK:
            mImgViewIcon.image = UIImage (named: "HomeWink")
            mLblNotice.text = "You have a wink"
            
        case Notification.TYPE_WINK_BACK:
            mImgViewIcon.image = UIImage (named: "SettingProfile")
            mLblNotice.text = "A user winked you back"
            
        case Notification.TYPE_MESSAGE:
            mImgViewIcon.image = UIImage (named: "HomeMail")
            mLblNotice.text = "You have 4 unread messages"
            
        default:
            break
        }
    }
}
