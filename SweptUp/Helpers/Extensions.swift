//
//  Extensions.swift
//  SweptUp
//
//  Created by Administrator on 6/12/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import Foundation
import UIKit
import Photos
import GoogleMaps

extension UIApplication {
    
    /// For setting background color of status bar
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

extension UIView {
    
    /// fille round
    func makeRound() {
        let radius: CGFloat = self.frame.size.height / 2.0
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
    }
    
    func makeRoundBorder(width: CGFloat = 1.0, color: UIColor = UIColor.white) {
        makeRound()
        
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
}

extension UIButton {
    func makeEnable(enable: Bool) {
        self.isEnabled = enable
        self.alpha = enable ? 1 : 0.6
    }
}

extension Date {
    func toReadableString() -> String {
        return toString(format: "MMMM dd, yyyy HH:mm:ss")
    }
    
    func toString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func toKey() -> String {
        return toString(format: "yyyyMMddHHmmss")
    }
}


extension UIViewController {
    
    func alertOk(title: String, message: String, cancelButton: String, cancelHandler: ((UIAlertAction) -> ())?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: cancelButton, style: .default, handler: cancelHandler)
        
        alertController.addAction(cancelAction)
        
        alertController.view.tintColor = UIColor.darkGray
        
        present(alertController, animated: true, completion: nil)
    }
    
    func alert(title: String, message: String, okButton: String, cancelButton: String, okHandler: ((UIAlertAction) -> ())?, cancelHandler: ((UIAlertAction) -> ())?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: okButton, style: .default, handler: okHandler)
        let cancelAction = UIAlertAction(title: cancelButton, style: .cancel, handler: cancelHandler)
        
        alertController.view.tintColor = UIColor.darkGray
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    /// show internet connection error
    func showConnectionError() {
        alertOk(title: "No internet connection",
                message: "Please connect to the internet and try again",
                cancelButton: "OK",
                cancelHandler: nil)
    }
    
    func showNavbar() {
        self.navigationController?.navigationBar.barTintColor = Constants.gColorTheme
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.font: SHTextHelper.lobster13Regular(size: 20),
            NSAttributedStringKey.foregroundColor: UIColor.white
        ]
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func hideNavbar(animated: Bool = false) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    static func takePhoto<T: UIViewController>(viewController: T) where T: UINavigationControllerDelegate, T: UIImagePickerControllerDelegate {
        let cameraMediaType = AVMediaType.video
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
        
        switch cameraAuthorizationStatus {
        case .denied: fallthrough
        case .restricted:
            viewController.alert(title: "Camera", message: "You are restricted using the camera. Go to settings to enable it.", okButton: "Go to Settings", cancelButton: "Cancel", okHandler: { (_) in
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }, cancelHandler: nil)
            break
        case .authorized:
            doTakePhoto(viewController: viewController)
            break
            
            
        case .notDetermined:
            // Prompting user for the permission to use the camera.
            AVCaptureDevice.requestAccess(for: cameraMediaType) { granted in
                if granted {
                    doTakePhoto(viewController: viewController)
                } else {
                    
                }
            }
        }
        
        
        
    }
    
    static func doTakePhoto<T: UIViewController>(viewController: T) where T: UINavigationControllerDelegate, T: UIImagePickerControllerDelegate {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            viewController.alert(title: "Camera", message: "You are restricted using the camera. Go to settings to enable it.", okButton: "Go to Settings", cancelButton: "Cancel", okHandler: { (_) in
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }, cancelHandler: nil)
            return
        }
        
        let picker = UIImagePickerController()
        picker.delegate = viewController
        picker.allowsEditing = true
        picker.sourceType = .camera
        
        viewController.present(picker, animated: true, completion: nil)
    }
    
    static func loadFromGallery<T: UIViewController>(viewController: T) where T: UINavigationControllerDelegate, T: UIImagePickerControllerDelegate{
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            //handle authorized status
            doLoadFromGallery(viewController: viewController)
            break
            
        case .denied, .restricted :
            //handle denied status
            
            viewController.alert(title: "Camera", message: "You are restricted using photo gallery. Go to settings to enable it.", okButton: "Go to Settings", cancelButton: "Cancel", okHandler: { (_) in
                guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }, cancelHandler: nil)
            
            return
        case .notDetermined:
            // ask for permissions
            PHPhotoLibrary.requestAuthorization() { status in
                switch status {
                case .authorized:
                    doLoadFromGallery(viewController: viewController)
                    // as above
                    break
                case .denied, .restricted:
                    // as above
                    break
                case .notDetermined:
                    // won't happen but still
                    break
                }
            }
        }
    }
    
    static func doLoadFromGallery<T: UIViewController>(viewController: T) where T: UINavigationControllerDelegate, T: UIImagePickerControllerDelegate {
        
        let picker = UIImagePickerController()
        picker.delegate = viewController
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        viewController.present(picker, animated: true, completion: nil)
    }
} 

extension String {
    var containsUppercase: Bool {
        let characterset = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        if self.rangeOfCharacter(from: characterset) != nil {
            return true
        } else {
            return false
        }
    }
    
    var containsLowercase: Bool {
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz")
        if self.rangeOfCharacter(from: characterset) != nil {
            return true
        } else {
            return false
        }
    }
    
    var containsNumber: Bool {
        let characterset = CharacterSet(charactersIn: "0123456789")
        if self.rangeOfCharacter(from: characterset) != nil {
            return true
        } else {
            return false
        }
    }
}

extension UIImage {
    func crop(toRect rect:CGRect) -> UIImage{
        let imageRef:CGImage = self.cgImage!.cropping(to: rect)!
        let cropped:UIImage = UIImage(cgImage:imageRef)
        return cropped
    }
    
    func resized(toWidth width: CGFloat) -> UIImage{
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
    
    func resized(toWidth width: CGFloat, toHeight height: CGFloat) -> UIImage{
        let canvasSize = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()!
    }
}

extension GMSMapView {
    func getCenterCoordinate() -> CLLocationCoordinate2D {
        let centerPoint = self.center
        let centerCoordinate = self.projection.coordinate(for: centerPoint)
        return centerCoordinate
    }
    
    func getTopCenterCoordinate() -> CLLocationCoordinate2D {
        // to get coordinate from CGPoint of your map
        let topCenterCoor = self.convert(CGPoint(x: self.frame.size.width, y: 0), from: self)
        let point = self.projection.coordinate(for: topCenterCoor)
        return point
    }
    
    func getRadius() -> CLLocationDistance {
        let centerCoordinate = getCenterCoordinate()
        let centerLocation = CLLocation(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
        let topCenterCoordinate = self.getTopCenterCoordinate()
        let topCenterLocation = CLLocation(latitude: topCenterCoordinate.latitude, longitude: topCenterCoordinate.longitude)
        let radius = CLLocationDistance(centerLocation.distance(from: topCenterLocation))
        return round(radius)
    }
}
