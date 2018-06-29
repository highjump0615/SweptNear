//
//  Wink.swift
//  SweptUp
//
//  Created by Administrator on 6/28/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import Foundation
import Firebase

enum WinkStatus : String {
    case waiting = "waiting"
    case ignored = "ignored"
}

class Wink : BaseModel {
    
    //
    // table info
    //
    static let TABLE_NAME = "winks"
    static let FIELD_SENDER_ID = "senderId"
    static let FIELD_STATUS = "status"
    
    var senderId: String = ""
    var sender: User?
    
    var status: WinkStatus = WinkStatus.waiting
    
    override init() {
        super.init()
    }
    
    init(snapshot: DataSnapshot) {
        super.init()
        
        let info = snapshot.value! as! [String: Any?]

        self.id = snapshot.key
        self.senderId = info[Wink.FIELD_SENDER_ID] as! String
        self.status = WinkStatus(rawValue: info[Wink.FIELD_STATUS] as! String)!
    }
    
    override func tableName() -> String {
        return Wink.TABLE_NAME
    }
    
    override func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        
        dict[Wink.FIELD_SENDER_ID] = self.senderId
        dict[Wink.FIELD_STATUS] = self.status.rawValue
        
        return dict
    }
}
