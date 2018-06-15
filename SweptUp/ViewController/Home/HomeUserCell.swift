//
//  HomeUserCell.swift
//  SweptUp
//
//  Created by Administrator on 6/15/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit

class HomeUserCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mLblEmpty: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
