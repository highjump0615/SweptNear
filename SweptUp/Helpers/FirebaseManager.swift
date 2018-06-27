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
    static var ServerOffset = 0.0
    static let mAuth = Auth.auth()
    
    static func ref() -> DatabaseReference {
        return Database.database().reference()
    }
    
    static func sref() -> StorageReference {
        let storageURL = FirebaseApp.app()?.options.storageBucket
        return Storage.storage().reference(forURL: "gs://" + storageURL!)
    }

    static func initServerTime() {
        let serverTiemQuery = FirebaseManager.ref().child(".info/serverTimeOffset")
        serverTiemQuery.observeSingleEvent(of: .value) { (snapshot) in
            FirebaseManager.ServerOffset = snapshot.value as? Double ?? 0
        }
    }
    
    static func uploadImageTo( path: String,
                               image: UIImage!,
                               completionHandler: @escaping (_ downloadURL: String?, _ error: Error?)->()) {
        let data = UIImagePNGRepresentation(image)
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        
        FirebaseManager.sref().child(path).putData(data!, metadata: metaData) { (metadata, error) in
            if let error = error {
                completionHandler(nil, error)
                return
            }
            
            if let path = metadata?.path {
                let gsPath = sref().child(path).description
                let gsRef = Storage.storage().reference(forURL: gsPath)
                
                gsRef.downloadURL(completion: { (url, error) in
                    if let error = error {
                        completionHandler(nil, error)
                    } else {
                        completionHandler(url!.absoluteString, nil)
                    }
                })
            }
        }
    }
    
    static func signOut() {
        // Log out
        do {
            try FirebaseManager.mAuth.signOut()
        }
        catch {
        }
    }
}
