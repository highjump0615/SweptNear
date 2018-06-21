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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        mViewPhoto.layer.shadowColor = UIColor.black.cgColor
        mViewPhoto.layer.shadowOpacity = 0.7
        mViewPhoto.layer.shadowOffset = CGSize.zero
        mViewPhoto.layer.shadowRadius = 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
 
        mViewPhoto.makeRound()
    }
}
