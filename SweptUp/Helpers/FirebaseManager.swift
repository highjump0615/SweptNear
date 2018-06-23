//
//  FirebaseManager.swift
//  SweptUp
//
//  Created by Administrator on 6/24/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import Foundation
import Firebase

class FirebaseManager {
    static func ref() -> DatabaseReference {
        return Database.database().reference()
    }

}
