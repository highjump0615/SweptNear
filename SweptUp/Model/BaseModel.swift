//
//  BaseModel.swift
//  SweptUp
//
//  Created by Administrator on 6/24/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import Foundation

class BaseModel {
    
    //
    // table info
    //
    static let FIELD_DATE = "createdAt"
    
    var id = ""
    var createdAt: Int
    
    init() {
        createdAt = 0
    }
    
    func tableName() -> String {
        // virtual func
        return "base"
    }
    
    func toDictionary() -> NSDictionary {
        // virtual func
        return NSDictionary()
    }
    
    func saveToDatabase(withID: String? = nil) {
        let database = FirebaseManager.ref().child(tableName())
        
        if withID != nil && (withID?.isEmpty)! {
            self.id = withID!
        }
        else if self.id.isEmpty {
            self.id = database.childByAutoId().key
        }
        
        database.child(self.id).setValue(self.toDictionary())
    }
}
