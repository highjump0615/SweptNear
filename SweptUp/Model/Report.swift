//
//  Report.swift
//  SweptUp
//
//  Created by Administrator on 7/12/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit
import Firebase

class Report: BaseModel {

    //
    // table info
    //
    static let TABLE_NAME = "reports"
    static let FIELD_SENDER_ID = "senderId"
    static let FIELD_DESC = "description"
    
    var description = ""
    
    var senderId: String = ""
    var sender: User?
    
    var user: User?
    
    override func tableName() -> String {
        return Report.TABLE_NAME
    }
    
    override init() {
        super.init()
    }
    
    init(snapshot: DataSnapshot) {
        super.init()
        
        let info = snapshot.value! as! [String: Any?]
        
        self.id = snapshot.key
        
        self.description = info[Report.FIELD_DESC] as! String
        self.senderId = info[Report.FIELD_SENDER_ID] as! String
    }
    
    override func toDictionary() -> [String: Any] {
        var dict = super.toDictionary()
        
        dict[Report.FIELD_SENDER_ID] = self.senderId
        dict[Report.FIELD_DESC] = self.description
        
        return dict
    }
}
