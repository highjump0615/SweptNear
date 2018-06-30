//
//  HomeUserCollectionCell.swift
//  SweptUp
//
//  Created by Administrator on 6/15/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit
import SDWebImage

class HomeUserCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var mViewBg: UIView!
    @IBOutlet weak var mImgViewUser: UIImageView!
    
    func fillContent(data: BaseModel) {
        if data is Message {
            let msg = data as! Message
            mViewBg.isHidden = msg.read
        }
        else {
            let wink = data as! Wink
            if let photoUrl = wink.sender?.photoUrl {
                mImgViewUser.sd_setImage(with: URL(string: photoUrl),
                                         placeholderImage: UIImage(named: "UserDefault"),
                                         options: .progressiveDownload,
                                         completed: nil)
            }            
        }
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)

        // init view
        let radius: CGFloat = layoutAttributes.size.height / 2.0
        mViewBg.layer.cornerRadius = radius
        
        mImgViewUser.layer.masksToBounds = true
        mImgViewUser.layer.cornerRadius = radius - 3
    }
}
