SweptNear
======

> iOS App for chatting with users nearby

## Overview

### 1. Main Features
- User management  
Signup, Login, Profile, Setting, ...

#### 1.1 Admin Version
- User management  
User list, Ban/Unban User ...
- Report management  
Report list, Delete Report

#### 1.2 User Version
- Showing users on the map  
  - Send wink to user  
- Chat with the users  
 
### 2. Techniques 
Main language: Swift 4.0  
#### 2.1 UI Implementation  
- Implementing view controllers with individual xib interface  
- TableView cell and CollectionView cell should be implemented independent xib file  
  - Register nib for table view & collection view cell  
``UITableView.register()``  
``UICollectionView.register()``  
  - Getting correct cell size in ``apply()``
``UICollectionViewCell.apply(layoutAttributes)``  
- Custom fonts  
  - Navigation bar title
- Different color on top and bottom bouncing part in UITableView   
  - Profile page  
  
#### 2.2 Function Implementation
- Getting location using ``CLLocationManager()``  
``locationManager.startUpdatingLocation()``  
- Google Firebase for backend  
- Push notification using Firebase Clound Messaging(FCM)
  - [Sending push notification from App](https://firebase.google.com/docs/cloud-messaging/send-message)

#### 2.3 Code tricks  
- Methods with completion callback using closures  
```swift  
func readFromDatabaseChild(withField: String, completion: @escaping((Any?)->())) {
}
```  

#### 2.4 Third-Party Libraries
- [IHKeyboardAvoiding](https://github.com/IdleHandsApps/IHKeyboardAvoiding) v4.2  
  - Sign in page, Sign up page, ...  
- [Google Firebase](https://github.com/firebase/firebase-ios-sdk) v4.9.0  
  - Firebase Auth  
  - Firebase Database  
  - Firebase Storage  
  - Firebase Messaging  
- [Firebase Geofire](https://github.com/firebase/geofire-objc) v1.0.1  
- [ReachabilitySwift](https://github.com/ashleymills/Reachability.swift) v2.3.3  
  - Checking network status  
- [SDWebImage](https://github.com/rs/SDWebImage) v4.3.0  
  - Caching all images  
  - Save image to cache  
``SDWebImageManager.shared().saveImage()``  
- GoogleMaps v2.7.0, GooglePlaces v2.7.0  
[https://developers.google.com/maps/documentation/ios-sdk/intro](https://developers.google.com/maps/documentation/ios-sdk/intro)  
- [SVProgressHUD](https://github.com/SVProgressHUD/SVProgressHUD) v2.2.3  
- [EmptyDataSet-Swift](https://github.com/Xiaoye220/EmptyDataSet-Swift) v4.0.5  
TableView / CollectionView with empty notice  
- [KMPlaceholderTextView](https://github.com/MoZhouqi/KMPlaceholderTextView) v1.3.0  
  - TextView in report page  
- [Alamofire](https://github.com/Alamofire/Alamofire) v4.7.2  
Calling & Fetching data from Rest Api  
  - Send push notification to FCM server  

## Need to Improve
- Add and improve features
