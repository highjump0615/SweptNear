//
//  ProfilePhotoCollectionCell.swift
//  SweptUp
//
//  Created by Administrator on 6/26/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit

class ProfilePhotoCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var mImgViewPhoto: UIImageView!
    
    func fillContent(image: UIImage) {
        mImgViewPhoto.image = image
    }
    
    func fillContent(url: String) {
        mImgViewPhoto.sd_setImage(with: URL(string: url),
                                  placeholderImage: UIImage(named: "UserDefault"),
                                  options: .progressiveDownload,
                                  completed: nil)
    }
}
