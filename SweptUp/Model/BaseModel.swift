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
    
    func toDictionary() -> [String: Any] {
        // virtual func
        return [:]
    }
    
    func saveToDatabase(withID: String? = nil, parentID: String? = nil) {
        var strDb = tableName()
        if let parent = parentID {
            strDb += "/" + parent
        }
        
        let database = FirebaseManager.ref().child(strDb)
        
        if let strId = withID, !strId.isEmpty {
            self.id = strId
        }
        else if self.id.isEmpty {
            self.id = database.childByAutoId().key
        }
        
        database.child(self.id).setValue(self.toDictionary())
    }
    
    func isEqual(to: BaseModel) -> Bool {
        return id == to.id
    }
}
