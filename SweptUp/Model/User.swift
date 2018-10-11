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
import Firebase

class User : BaseModel {
    
    static let USER_TYPE_NORMAL = 0
    static let USER_TYPE_ADMIN = 1
    
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
    static let FIELD_AVAILABLE = "available"
    static let FIELD_TOKEN = "token"
    
    static let TABLE_NAME_PHOTOS = "photos"
    static let TABLE_NAME_GEOLOCATION = "geolocations"
    
    static let TABLE_NAME_BLOCK = "usersBlocked"
    
    static var currentUser: User?
    
    var email = ""
    
    var firstName = ""
    var lastName = ""
    var birthday: String? //format: year/month/day
    var gender: String?
    var photoUrl: String?
    var banned: Bool = false
    var type = User.USER_TYPE_NORMAL
    
    var token: String?
    
    // wink available
    var available: Bool = true
    var photos: [String] = []
    
    // blocked users
    var usersBlocked: [String] = []
    
    //
    // excludes
    //
    var password = ""
    var location: CLLocation?
    
    var winksSent: [Wink] = []
    var winksReceived: [Wink] = []
    
    override init() {
        super.init()
    }
    
    init(withId: String) {
        super.init()
        
        self.id = withId
    }
    
    init(snapshot: DataSnapshot) {
        super.init()
        
        let info = snapshot.value! as! [String: Any?]
        
        self.id = snapshot.key
        
        self.email = info[User.FIELD_EMAIL] as! String
        
        // first name
        if let firstName = info[User.FIELD_FIRSTNAME] {
            self.firstName = firstName as! String
        }
        
        // last name
        if let lastName = info[User.FIELD_LASTNAME] {
            self.lastName = lastName as! String
        }
        
        self.birthday = info[User.FIELD_BIRTHDAY] as? String
        self.gender = info[User.FIELD_GENDER] as? String
        self.photoUrl = info[User.FIELD_PHOTO] as? String
        self.token = info[User.FIELD_TOKEN] as? String
        
        // banned
        if let b = info[User.FIELD_BANNED] {
            self.banned = b as! Bool
        }
        
        // availability
        if let availability = info[User.FIELD_AVAILABLE] {
            self.available = availability as! Bool
        }
        
        // type
        if let t = info[User.FIELD_TYPE] {
            self.type = t as! Int
        }
    }
    
    override func tableName() -> String {
        return User.TABLE_NAME
    }
    
    override func toDictionary() -> [String: Any] {
        var dict = super.toDictionary()

        dict[User.FIELD_EMAIL] = self.email
        dict[User.FIELD_FIRSTNAME] = self.firstName
        dict[User.FIELD_LASTNAME] = self.lastName
        dict[User.FIELD_BIRTHDAY] = self.birthday
        dict[User.FIELD_GENDER] = self.gender
        dict[User.FIELD_PHOTO] = self.photoUrl
        dict[User.FIELD_BANNED] = self.banned
        dict[User.FIELD_AVAILABLE] = self.available
        dict[User.FIELD_TOKEN] = self.token
        dict[User.FIELD_TYPE] = self.type
        
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
            
            let user = User(snapshot: snapshot)
            
            completion(user)
        })
    }
    
    func userFullName() -> String {
        return "\(firstName) \(lastName)"
    }
    
    /// fetch functions
    ///
    /// - Parameter completion: <#completion description#>
    func fetchPhotos(completion: @escaping(()->())) {
        let photoRef = FirebaseManager.ref().child(User.TABLE_NAME_PHOTOS).child(self.id)
        photoRef.observeSingleEvent(of: .value, with: { (snapshot) in
            // clear list
            self.photos.removeAll()
            
            // photos not found
            if !snapshot.exists() {
                completion()
                return
            }
            
            // parse photos
            if let aryPhoto = snapshot.value! as? [Any] {
                for p in aryPhoto {
                    if p is String {
                        self.photos.append(p as! String)
                    }
                }
            }
            
            completion()
        })
    }
    
    /// Fetch blocked users
    func fetchBlockedUsers() {
        let dbRef = FirebaseManager.ref().child(User.TABLE_NAME_BLOCK).child(self.id)
        dbRef.observeSingleEvent(of: .value, with: { (snapshot) in
            // clear list
            self.usersBlocked.removeAll()
            
            // photos not found
            if !snapshot.exists() {
                return
            }
            
            // parse user ids
            for userInfo in snapshot.children {
                let u = userInfo as! DataSnapshot
                self.usersBlocked.append(u.key)
            }
        })
    }
    
    func savePhotosToDb() {
        let database = FirebaseManager.ref().child(User.TABLE_NAME_PHOTOS)
        database.child(self.id).setValue(self.photos)
    }
    
    /// update location
    ///
    /// - Parameters:
    ///   - location: <#location description#>
    ///   - completion: <#completion description#>
    func update(location: CLLocation, completion:@escaping((Error?)->Void)) {
        self.location = location
        
        // save to geofire db
        let locationsRef = FirebaseManager.ref().child(User.TABLE_NAME_GEOLOCATION)
        let geoFire = GeoFire(firebaseRef: locationsRef)
        geoFire.setLocation(location, forKey: self.id, withCompletionBlock: { (error) in
            completion(error)
        })
    }
    
    func isBlockedUser(_ userId: String) -> Bool {
        return self.usersBlocked.contains(userId)
    }
    
    
    /// block or unblock user based on current state
    ///
    /// - Parameter userId: <#userId description#>
    func blockUser(_ userId: String?) {
        guard let strUserId = userId else {
            return
        }
        
        let dbRef = FirebaseManager.ref().child(User.TABLE_NAME_BLOCK).child(self.id)
        
        // already blocked, unblock user
        if let index = usersBlocked.index(of: strUserId) {
            usersBlocked.remove(at: index)
            
            // remove from db
            dbRef.child(strUserId).removeValue()
        }
        // block user
        else {
            usersBlocked.append(strUserId)
            
            // add to db
            dbRef.child(strUserId).setValue(true)
        }
    }
}
