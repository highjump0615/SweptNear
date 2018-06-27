//
//  HomeUserCollectionCell.swift
//  SweptUp
//
//  Created by Administrator on 6/15/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit

class HomeUserCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var mViewBg: UIView!
    @IBOutlet weak var mImgViewUser: UIImageView!
    
    func fillContent(data: Message) {
        mViewBg.isHidden = data.read
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
