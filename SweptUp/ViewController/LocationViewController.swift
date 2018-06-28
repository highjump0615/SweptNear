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
    
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initLocation()
        initMap()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // title
        self.tabBarController?.navigationItem.title = "Location"
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //
    // MARK: - CLLocationManagerDelegate
    //
    override func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        super.locationManager(manager, didUpdateLocations: locations)
        
        showMyLocation()
    }

}

extension LocationViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        //
        // load users in the area
        //
        let locationsRef = FirebaseManager.ref().child(User.TABLE_NAME_GEOLOCATION)
        let geoFire = GeoFire(firebaseRef: locationsRef)
        let centerLocation = mapView.getCenterCoordinate()
        let userCurrent = User.currentUser
        let radius = mapView.getRadius() / 1000.0 // in kilometers
        
        let query = geoFire.query(at: CLLocation(latitude: centerLocation.latitude,
                                                 longitude: centerLocation.longitude),
                                  withRadius: radius)
        query.observe(.keyEntered) { (key, location) in
            print("Entered:\(key) latitude:\(location.coordinate.latitude) longitude:\(location.coordinate.longitude)" )
            
            if key == userCurrent?.id { return } //ignore me
            
            User.readFromDatabase(withId: key, completion: { (user) in
                if let user = user {
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
        
        query.observeReady {
            print("ready")
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
