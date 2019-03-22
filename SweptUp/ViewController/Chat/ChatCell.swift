//
//  ChatCell.swift
//  SweptUp
//
//  Created by Administrator on 6/18/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit
import SDWebImage

class ChatCell: UITableViewCell {
    
    @IBOutlet weak var mButUser: UIButton!
    @IBOutlet weak var mLblName: UILabel!
    @IBOutlet weak var mLblText: UILabel!
    @IBOutlet weak var mLblTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        mButUser.makeRound()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillContent(msg: Message) {
        let userCurrent = User.currentUser!
        
        if let user = msg.sender {
            // user photo
            if let photoUrl = user.photoUrl {
                mButUser.sd_setImage(with: URL(string: photoUrl),
                                     for: .normal,
                                     placeholderImage: UIImage(named: "UserDefault"),
                                     options: .progressiveDownload,
                                     completed: nil)
            }
            
            // user name
            if !user.isEqual(to: userCurrent) {
                mLblName.text = user.userFullName()
            }
        }
        
        // text
        mLblText.text = msg.text
        
        // time
        // SENT 11:20 AM SEEN 11:25 AM
        mLblTime.text = Utils.stringFromTimestamp(timestamp: msg.createdAt)
    }

}
