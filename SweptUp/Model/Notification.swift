//
//  Notification.swift
//  SweptUp
//
//  Created by Administrator on 6/18/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import Foundation

class Notification : BaseModel {
    static let TYPE_WINK = 0
    static let TYPE_WINK_BACK = 1
    static let TYPE_MESSAGE = 2
    
    var type = Notification.TYPE_WINK
    
    var senderId: String = ""
    var sender: User?
}
