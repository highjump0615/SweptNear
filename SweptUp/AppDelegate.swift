//
//  AppDelegate.swift
//  SweptUp
//
//  Created by Administrator on 6/12/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UIApplication.shared.statusBarView?.backgroundColor = Constants.gColorTheme

        let backImage = UIImage(named: "Back")?.withRenderingMode(.alwaysOriginal)
        UINavigationBar.appearance().backIndicatorImage = backImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backImage

        // if logged in, go to home page directly
        let nav = UINavigationController()
        nav.navigationBar.tintColor = UIColor.white

//        let homeVC = HomeViewController(nibName: "HomeViewController", bundle: nil)
//        nav.setViewControllers([homeVC], animated: true)
//        UIApplication.shared.delegate?.window??.rootViewController = nav
        
//        // if tutorial has been read, go to log in page directly
//        if let tutorial = UserDefaults.standard.value(forKey: OnboardViewController.KEY_TUTORIAL) as? Bool, tutorial == true {
//            let signinVC = SignInViewController(nibName: "SignInViewController", bundle: nil)
//            nav.setViewControllers([signinVC], animated: true)
//            UIApplication.shared.delegate?.window??.rootViewController = nav
        let signinVC = SignInViewController(nibName: "SignInViewController", bundle: nil)
        nav.setViewControllers([signinVC], animated: true)
        UIApplication.shared.delegate?.window??.rootViewController = nav

//        }
        
        // google map initialization
        GMSServices.provideAPIKey(Config.googleMapApiKey)
        GMSPlacesClient.provideAPIKey(Config.googleMapApiKey)
        
        // firebase initialization
        FirebaseApp.configure()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

