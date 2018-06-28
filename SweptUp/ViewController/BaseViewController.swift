//
//  BaseViewController.swift
//  SweptUp
//
//  Created by Administrator on 6/17/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit
import SVProgressHUD
import CoreLocation

class BaseViewController: UIViewController {
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // clear title
        self.title = " "
    }
    
    /// go to main page according to user type
    func goToMain() {
        // go to home page with new navigation
        let homeVC = HomeViewController(nibName: "HomeViewController", bundle: nil)        
        self.navigationController?.setViewControllers([homeVC], animated: true)
    }
    
    /// show loading mast view
    ///
    /// - Parameter show: show/hide
    func showLoadingView(show: Bool = true) {
        if (SVProgressHUD.isVisible() && show) {
            // loading view is already shown
            return
        }
        
        SVProgressHUD.dismiss()
        
        if (show) {
            SVProgressHUD.setContainerView(self.view)
            SVProgressHUD.setDefaultMaskType(.gradient)
            SVProgressHUD.show()
        }
    }
    
    func initLocation() {
        //
        // init location
        //
        self.locationManager.requestWhenInUseAuthorization()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension BaseViewController: CLLocationManagerDelegate {
    //
    // MARK: - CLLocationManagerDelegate
    //
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else { return }
        
        print("\(location.coordinate.latitude) \(location.coordinate.longitude)")
        
        // update user location
        User.currentUser?.update(location: location, completion: { (error) in
            //ignore error message here
        })
    }
}
