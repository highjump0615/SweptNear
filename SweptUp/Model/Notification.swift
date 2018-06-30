//
//  Notification.swift
//  SweptUp
//
//  Created by Administrator on 6/18/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import Foundation
import Firebase

class Notification : BaseModel {
    static let TYPE_WINK = 0
    static let TYPE_WINK_BACK = 1
    static let TYPE_MESSAGE = 2
    
    //
    // table info
    //
    static let TABLE_NAME = "notifications"
    static let FIELD_SENDER_ID = "senderId"
    static let FIELD_TYPE = "type"
    
    var type = Notification.TYPE_WINK
    
    var senderId: String = ""
    var sender: User?
    
    override init() {
        super.init()
    }
    
    init(snapshot: DataSnapshot) {
        super.init()
        
        let info = snapshot.value! as! [String: Any?]
        
        self.id = snapshot.key
        self.senderId = info[Notification.FIELD_SENDER_ID] as! String
        self.type = info[Notification.FIELD_TYPE] as! Int
    }
    
    override func tableName() -> String {
        return Notification.TABLE_NAME
    }
    
    override func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        
        dict[Notification.FIELD_SENDER_ID] = self.senderId
        dict[Notification.FIELD_TYPE] = self.type
        
        return dict
    }
}
