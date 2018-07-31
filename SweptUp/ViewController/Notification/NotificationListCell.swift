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
        let strDesc = data.notificationDescription()
        
        switch data.type {
        case Notification.TYPE_WINK:
            mImgViewIcon.image = UIImage (named: "HomeWink")
            
        case Notification.TYPE_WINK_BACK:
            mImgViewIcon.image = UIImage (named: "SettingProfile")
            
        case Notification.TYPE_MESSAGE:
            mImgViewIcon.image = UIImage (named: "HomeMail")
            
        default:
            break
        }
        
        mLblNotice.text = strDesc
    }
}
