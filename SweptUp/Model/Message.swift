//
//  Message.swift
//  SweptUp
//
//  Created by Administrator on 6/15/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import Foundation
import Firebase

class Message : BaseModel {
    
    //
    // table info
    //
    static let TABLE_NAME = "messages"
    static let FIELD_SENDER_ID = "senderId"
    static let FIELD_TEXT = "text"

    var text: String = ""
    var read: Bool = true
    
    var senderId: String = ""
    var sender: User?
    
    override init() {
        super.init()
    }
    
    init(snapshot: DataSnapshot) {
        super.init()
        
        let info = snapshot.value! as! [String: Any?]
        
        self.id = snapshot.key
        self.senderId = info[Message.FIELD_SENDER_ID] as! String
        self.text = info[Message.FIELD_TEXT] as! String
    }
    
    override func tableName() -> String {
        return Message.TABLE_NAME
    }
    
    override func toDictionary() -> [String: Any] {
        var dict = super.toDictionary()
        
        dict[Message.FIELD_SENDER_ID] = self.senderId
        dict[Message.FIELD_TEXT] = text
        
        return dict
    }
}
