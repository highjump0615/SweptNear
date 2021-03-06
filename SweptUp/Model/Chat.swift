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
    static let FIELD_READ_AT = "readAt"
    
    var senderId: String = ""
    var sender: User?
    
    var updatedAt: Int64 = 0
    var readAt: Int64 = 0
    
    var text: String = ""
    
    // excluded
    var userRelated: User?
    
    override init() {
        super.init()
    }
    
    init(snapshot: DataSnapshot) {
        super.init()
        
        let info = snapshot.value! as! [String: Any?]
        
        self.id = snapshot.key
        self.senderId = info[Chat.FIELD_SENDER_ID] as! String
        self.text = info[Chat.FIELD_TEXT] as! String
        self.updatedAt = info[Chat.FIELD_UPDATED_AT] as! Int64
        
        // read at
        if let readAt = info[Chat.FIELD_READ_AT] {
            self.readAt = readAt as! Int64
        }
    }
    
    override func tableName() -> String {
        return Chat.TABLE_NAME
    }
    
    override func toDictionary() -> [String: Any] {
        var dict = super.toDictionary()
        
        dict[Chat.FIELD_SENDER_ID] = self.senderId
        dict[Chat.FIELD_TEXT] = text
        dict[Chat.FIELD_UPDATED_AT] = FirebaseManager.getServerLongTime()
        dict[Chat.FIELD_READ_AT] = self.readAt
        
        return dict
    }
    
    /// mark chat as read
    func markRead(withID: String?, parentId: String?) {
        readAt = FirebaseManager.getServerLongTime()
        
        saveToDatabase(withField: Chat.FIELD_READ_AT,
                       value: readAt,
                       withID: withID,
                       parentID: parentId)
    }
    
    func isRead() -> Bool {
        return readAt > updatedAt
    }
}
