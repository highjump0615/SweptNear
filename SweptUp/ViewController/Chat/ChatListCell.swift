//
//  ChatListCell.swift
//  SweptUp
//
//  Created by Administrator on 7/2/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit
import SDWebImage

class ChatListCell: UITableViewCell {
    
    @IBOutlet weak var mButImg: UIButton!
    @IBOutlet weak var mLblName: UILabel!
    @IBOutlet weak var mLblText: UILabel!
    @IBOutlet weak var mLblTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        mButImg.makeRound()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillContent(chat: Chat) {
        if let user = chat.userRelated {
            // user photo
            if let photoUrl = user.photoUrl {
                mButImg.sd_setImage(with: URL(string: photoUrl),
                                     for: .normal,
                                     placeholderImage: UIImage(named: "UserDefault"),
                                     options: .progressiveDownload,
                                     completed: nil)
            }
            
            // user name
            mLblName.text = user.userFullName()
        }
        
        // text
        mLblText.text = chat.text
        
        // time
        // SENT 11:20 AM SEEN 11:25 AM
        mLblTime.text = Utils.stringFromTimestampSimple(timestamp: chat.updatedAt)
    }

}
