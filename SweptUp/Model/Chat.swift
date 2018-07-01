//
//  Caht.swift
//  SweptUp
//
//  Created by Administrator on 6/30/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import Foundation
import Firebase

class Chat : BaseModel {
    
    //
    // table info
    //
    static let TABLE_NAME = "chats"
    static let FIELD_SENDER_ID = "senderId"
    static let FIELD_TEXT = "text"
    static let FIELD_UPDATED_AT = "updatedAt"
    
    var senderId: String = ""
    var sender: User?
    
    var updatedAt: Int = 0
    
    var text: String = ""
    
    override init() {
        super.init()
    }
    
    init(snapshot: DataSnapshot) {
        super.init()
        
        let info = snapshot.value! as! [String: Any?]
        
        self.senderId = info[Chat.FIELD_SENDER_ID] as! String
    }
    
    override func tableName() -> String {
        return Chat.TABLE_NAME
    }
    
    override func toDictionary() -> [String: Any] {
        var dict = super.toDictionary()
        
        dict[Chat.FIELD_SENDER_ID] = self.senderId
        dict[Chat.FIELD_TEXT] = text
        dict[Chat.FIELD_UPDATED_AT] = FirebaseManager.getServerLongTime()
        
        return dict
    }
}
