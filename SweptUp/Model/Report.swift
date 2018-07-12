//
//  Report.swift
//  SweptUp
//
//  Created by Administrator on 7/12/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit

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
    
    override func tableName() -> String {
        return Report.TABLE_NAME
    }
    
    override func toDictionary() -> [String: Any] {
        var dict = super.toDictionary()
        
        dict[Report.FIELD_SENDER_ID] = self.senderId
        dict[Report.FIELD_DESC] = self.description
        
        return dict
    }
}
