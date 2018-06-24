//
//  User.swift
//  SweptUp
//
//  Created by Administrator on 6/15/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import Foundation

enum UserType : String {
    case user = "user"
    case admin = "admin"
}

class User : BaseModel {
    
    //
    // table info
    //
    static let TABLE_NAME = "users"
    static let FIELD_EMAIL = "email"
    static let FIELD_FIRSTNAME = "firstName"
    static let FIELD_LASTNAME = "lastName"
    static let FIELD_BIRTHDAY = "birthday"
    static let FIELD_GENDER = "gender"
    static let FIELD_PHOTO = "photoUrl"
    static let FIELD_TYPE = "type"
    static let FIELD_BANNED = "banned"
    
    static var currentUser: User?
    
    var email = ""
    
    var firstName = ""
    var lastName = ""
    var birthday: String? //format: year/month/day
    var gender: String?
    var photoUrl: String?
    var banned: Bool = false
    
    var deviceToken: String?
    
    //
    // excludes
    //
    var password = ""
    
    override func tableName() -> String {
        return User.TABLE_NAME
    }
    
    override func toDictionary() -> NSDictionary {
        var dict = Dictionary<String, Any>()

        dict[User.FIELD_EMAIL] = self.email
        dict[User.FIELD_FIRSTNAME] = self.firstName
        dict[User.FIELD_LASTNAME] = self.lastName
        dict[User.FIELD_BIRTHDAY] = self.birthday
        dict[User.FIELD_GENDER] = self.gender
        dict[User.FIELD_PHOTO] = self.photoUrl
        dict[User.FIELD_BANNED] = self.banned
        
        return NSDictionary(dictionary: dict)
    }
}
