//
//  ProfileUserCell.swift
//  SweptUp
//
//  Created by Administrator on 6/18/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit

class ProfileUserCell: UITableViewCell {

    @IBOutlet weak var mViewPhoto: UIView!
    @IBOutlet weak var mButSend: UIButton!
    @IBOutlet weak var mButIgnore: UIButton!
    @IBOutlet weak var mImgviewPhoto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        mViewPhoto.layer.shadowColor = UIColor.black.cgColor
        mViewPhoto.layer.shadowOpacity = 0.7
        mViewPhoto.layer.shadowOffset = CGSize.zero
        mViewPhoto.layer.shadowRadius = 5
        
        mButSend.isHidden = true
        mButIgnore.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
 
        mViewPhoto.makeRound()
        mImgviewPhoto.makeRound()
    }
    
    func fillContent(user: User, wink: Wink?) {
        let userCurrent = User.currentUser!
        
        // button text
        if let w = wink {
            if w.senderId == userCurrent.id {
                // already sent wink
                mButSend.setTitle("Sent Wink", for: .normal)
                mButSend.makeEnable(enable: false)
            }
            
            mButSend.isHidden = false
        }
        
        // photo
        if let photoUrl = user.photoUrl {
            mImgviewPhoto.sd_setImage(with: URL(string: photoUrl),
                                      placeholderImage: UIImage(named: "UserDefault"),
                                      options: .progressiveDownload,
                                      completed: nil)
        }
        
    }
}
