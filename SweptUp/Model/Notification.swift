//
//  Notification.swift
//  SweptUp
//
//  Created by Administrator on 6/18/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import Foundation
import Firebase
import Alamofire

class Notification : BaseModel {
    static let TYPE_WINK = 0
    static let TYPE_WINK_BACK = 1
    static let TYPE_MESSAGE = 2
    
    //
    // table info
    //
    static let TABLE_NAME = "notifications"
    static let FIELD_SENDER_ID = "senderId"
    static let FIELD_TYPE = "type"
    
    var type = Notification.TYPE_WINK
    
    var senderId: String = ""
    var sender: User?
    
    override init() {
        super.init()
    }
    
    init(snapshot: DataSnapshot) {
        super.init()
        
        let info = snapshot.value! as! [String: Any?]
        
        self.id = snapshot.key
        self.senderId = info[Notification.FIELD_SENDER_ID] as! String
        self.type = info[Notification.FIELD_TYPE] as! Int
    }
    
    override func tableName() -> String {
        return Notification.TABLE_NAME
    }
    
    override func toDictionary() -> [String: Any] {
        var dict = super.toDictionary()
        
        dict[Notification.FIELD_SENDER_ID] = self.senderId
        dict[Notification.FIELD_TYPE] = self.type
        
        return dict
    }
    
    func notificationDescription() -> String {
        var strDesc = ""
        
        switch type {
        case Notification.TYPE_WINK:
            strDesc = "You have a wink"
            
        case Notification.TYPE_WINK_BACK:
            strDesc = "A user winked you back"

        default:
            break
        }
        
        return strDesc
    }
    
    /// send push notification to specific user
    ///
    /// - Parameters:
    ///   - receiver: <#receiver description#>
    ///   - message: <#message description#>
    ///   - title: <#title description#>
    static func sendPushNotification(receiver: User, message: String = "", title: String = "") {
        let url = "https://fcm.googleapis.com/fcm/send"
        
        if let deviceToken = receiver.token {
            let headers: HTTPHeaders = ["Authorization": "key=\(Config.fcmAuthKey)",
                                        "Content-Type": "application/json"]
            let parameters : Parameters = ["notification":
                [
                    "title": title,
                    "body" : message,
                    "sound" : "default"
                ],
               "to":deviceToken]
            
            print(headers)
            print(parameters)
            
            Alamofire.request(url,
                              method: .post,
                              parameters: parameters,
                              encoding: JSONEncoding.default,
                              headers: headers)
                .validate()
                .responseJSON(completionHandler: { (response) in
                    switch response.result {
                    case .success(let val):
                        print(val)
                    case .failure(let val):
                        print(val)
                    }
            })
            
        }
    }
}
