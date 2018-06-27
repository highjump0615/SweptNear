//
//  User.swift
//  SweptUp
//
//  Created by Administrator on 6/15/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import Foundation
import CoreLocation
import GeoFire

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
    static let FIELD_PHOTOS = "photos"
    
    static var currentUser: User?
    
    var email = ""
    
    var firstName = ""
    var lastName = ""
    var birthday: String? //format: year/month/day
    var gender: String?
    var photoUrl: String?
    var banned: Bool = false
    
    var photos: [String] = []
    
    var deviceToken: String?
    
    //
    // excludes
    //
    var password = ""
    
    override func tableName() -> String {
        return User.TABLE_NAME
    }
    
    override func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]

        dict[User.FIELD_EMAIL] = self.email
        dict[User.FIELD_FIRSTNAME] = self.firstName
        dict[User.FIELD_LASTNAME] = self.lastName
        dict[User.FIELD_BIRTHDAY] = self.birthday
        dict[User.FIELD_GENDER] = self.gender
        dict[User.FIELD_PHOTO] = self.photoUrl
        dict[User.FIELD_BANNED] = self.banned
        dict[User.FIELD_PHOTOS] = self.photos
        
        return dict
    }
    
    static func readFromDatabase(withId: String, completion: @escaping((User?)->())) {
        let userRef = FirebaseManager.ref().child(TABLE_NAME).child(withId)
        
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            // user not found
            if !snapshot.exists() {
                completion(nil)
                return
            }
            
            let info = snapshot.value! as! [String: Any?]
            let user = User()
            
            user.id = snapshot.key
            
            user.email = info[User.FIELD_EMAIL] as! String
            user.firstName = info[User.FIELD_FIRSTNAME] as! String
            user.lastName = info[User.FIELD_LASTNAME] as! String
            user.birthday = info[User.FIELD_BIRTHDAY] as? String
            user.gender = info[User.FIELD_GENDER] as? String
            user.photoUrl = info[User.FIELD_PHOTO] as? String
            user.banned = info[User.FIELD_BANNED] as! Bool
            
            // parse photos
            if let aryPhoto = info[User.FIELD_PHOTOS] as? [Any] {
                for p in aryPhoto {
                    if p is String {
                        user.photos.append(p as! String)
                    }
                }
            }

            completion(user)
        })
    }
    
    
    /// update location
    ///
    /// - Parameters:
    ///   - location: <#location description#>
    ///   - completion: <#completion description#>
    func update(location: CLLocation, completion:@escaping((Error?)->Void)) {
        let usersRef = FirebaseManager.ref().child(tableName())
        let geoFire = GeoFire(firebaseRef: usersRef)
        geoFire.setLocation(location, forKey: self.id, withCompletionBlock: { (error) in
            completion(error)
        })
    }
}
