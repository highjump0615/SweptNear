//
//  BaseModel.swift
//  SweptUp
//
//  Created by Administrator on 6/24/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import Foundation
import Firebase

class BaseModel {
    
    //
    // table info
    //
    static let FIELD_DATE = "createdAt"
    
    var id = ""
    var createdAt: Int64
    
    init() {
        createdAt = FirebaseManager.getServerLongTime()
    }
    
    func tableName() -> String {
        // virtual func
        return "base"
    }
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        dict[BaseModel.FIELD_DATE] = createdAt
        
        return dict
    }
    
    private func getDatabaseRef(withID: String? = nil, parentID: String? = nil) -> DatabaseReference {
        var strDb = tableName()
        if let parent = parentID {
            strDb += "/" + parent
        }
        
        let database = FirebaseManager.ref().child(strDb)
        
        if let strId = withID, !strId.isEmpty {
//            self.id = strId
        }
        else if self.id.isEmpty {
            self.id = database.childByAutoId().key
        }
        
        return database.child(self.id)
    }
    
    /// save entire object to database
    ///
    /// - Parameters:
    ///   - withID: <#withID description#>
    ///   - parentID: <#parentID description#>
    func saveToDatabase(withID: String? = nil, parentID: String? = nil) {
        let db = getDatabaseRef(withID: withID, parentID: parentID)
        db.setValue(self.toDictionary())
    }
    
    /// save child value to databse
    ///
    /// - Parameters:
    ///   - withField: <#withField description#>
    ///   - value: <#value description#>
    ///   - withID: <#withID description#>
    ///   - parentID: <#parentID description#>
    func saveToDatabase(withField: String?, value: Any, withID: String? = nil, parentID: String? = nil) {
        let db = getDatabaseRef(withID: withID, parentID: parentID)
        db.child(withField!).setValue(value)
    }
    
    func isEqual(to: BaseModel) -> Bool {
        return id == to.id
    }
}
