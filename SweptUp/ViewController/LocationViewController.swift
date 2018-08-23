//
//  LocationViewController.swift
//  SweptUp
//
//  Created by Administrator on 6/17/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit
import GoogleMaps
import GeoFire

class LocationViewController: BaseViewController {

    @IBOutlet weak var mViewMap: GMSMapView!
    @IBOutlet weak var mViewTopbar: UIView!
    @IBOutlet weak var mViewFilter: UIView!
    @IBOutlet weak var mConstraintFilterBottom: NSLayoutConstraint!
    
    @IBOutlet weak var mLblDistance: UILabel!
    @IBOutlet weak var mSliderDistance: UISlider!
    
    var users: [User] = []
    var mqueryLocation: GFCircleQuery? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLocation()
        initMap()
        
        let colorGray = UIColor(red: 75/255.0, green: 75/255.0, blue: 75/255.0, alpha: 0.4)
        self.mViewTopbar.addBottomBorderWithColor(color: colorGray, width: 1.0)
        
        // init distance filter
        onDistanceChanged(self.view)        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // title
        self.tabBarController?.navigationItem.title = "Location"
        mqueryLocation = nil
    }
    
    func initMap() {
        mViewMap.isMyLocationEnabled = true
        mViewMap.settings.myLocationButton = true
        mViewMap.delegate = self
        
        showMyLocation()
    }
    
    func showMyLocation() {
        if let l = User.currentUser?.location {
            let camera = GMSCameraPosition.camera(withLatitude: l.coordinate.latitude,
                                                  longitude: l.coordinate.longitude,
                                                  zoom: 16.0)
            mViewMap.camera = camera
        }
    }
    
    func addMarkerOnMap(location: CLLocation, userInfo: User) {
        // custom marker view with user photo
        let markerWidth = 30.0
        let markerImgView = UIImageView(frame: CGRect(x: 0, y: 0,
                                                      width: markerWidth, height: markerWidth))
        markerImgView.sd_setImage(with: URL(string: userInfo.photoUrl!),
                                  placeholderImage: UIImage(named: "UserDefault"),
                                  options: .progressiveDownload,
                                  completed: nil)
        markerImgView.makeRoundBorder(width: 1.0, color: Constants.gColorTheme)
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = location.coordinate
        marker.iconView = markerImgView
        marker.snippet = userInfo.id
        marker.map = mViewMap
    }
    
    @IBAction func onButFilter(_ sender: Any) {
        // show/hide distance slider
        UIView.animate(withDuration: 0.3) {
            if self.mConstraintFilterBottom.constant == 0 {
               self.mConstraintFilterBottom.constant = self.mViewFilter.frame.height
            }
            else {
                self.mConstraintFilterBottom.constant = 0
            }
            
            self.view .layoutIfNeeded()
        }
    }
    
    @IBAction func onSliderTouchUp(_ sender: Any) {
        //
        // load users in the area
        //
        let locationsRef = FirebaseManager.ref().child(User.TABLE_NAME_GEOLOCATION)
        let geoFire = GeoFire(firebaseRef: locationsRef)
        let userCurrent = User.currentUser
        
        if let location = self.mViewMap.myLocation {
            mqueryLocation?.removeAllObservers()
            
            mqueryLocation = geoFire.query(at: CLLocation(latitude: location.coordinate.latitude,
                                                         longitude: location.coordinate.longitude),
                                          withRadius: Double(mSliderDistance.value))
            mqueryLocation?.observe(.keyEntered) { (key, location) in
                print("Entered:\(key) latitude:\(location.coordinate.latitude) longitude:\(location.coordinate.longitude)" )
                
                if key == userCurrent?.id { return } //ignore me
                
                User.readFromDatabase(withId: key, completion: { (user) in
                    if let user = user {
                        // only shows available user
                        if !user.available {
                            return
                        }
                        
                        // ignore banned user
                        if user.banned {
                            return
                        }
                        
                        // ignore admin user
                        if user.type == User.USER_TYPE_ADMIN {
                            return
                        }
                        
                        if let _ = self.users.index(where: {$0.id == key}) {
                        }
                        else {
                            self.users.append(user)
                            
                            // add user to map
                            self.addMarkerOnMap(location: location, userInfo: user)
                        }
                    }
                })
            }
            
            mqueryLocation?.observeReady {
                print("ready")
            }
        }
    }
    
    @IBAction func onDistanceChanged(_ sender: Any) {
        mLblDistance.text = "Maximum of \(mSliderDistance.value) km"
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

extension LocationViewController: GMSMapViewDelegate {
    
    /// init done
    ///
    /// - Parameters:
    ///   - mapView: <#mapView description#>
    ///   - position: <#position description#>
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        // fetch near users only for the first time
        if mqueryLocation == nil {
            onSliderTouchUp(self.view)
        }
    }
    
    func mapViewDidFinishTileRendering(_ mapView: GMSMapView) {
        
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        // hide distance slider
        UIView.animate(withDuration: 0.3) {
            self.mConstraintFilterBottom.constant = 0
            self.view .layoutIfNeeded()
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let user = self.users.first(where: {$0.id == marker.snippet!})
            
        // go to profile page
        let profileVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        profileVC.mUser = user
        self.navigationController?.pushViewController(profileVC, animated: true)
        
        return true
    }
}
