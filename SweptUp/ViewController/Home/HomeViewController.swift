//
//  HomeViewController.swift
//  SweptUp
//
//  Created by Administrator on 6/14/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit
import CoreLocation

class HomeConstantCV {
    static let column: CGFloat = 4
    
    static let minLineSpacing: CGFloat = 16.0
    static let minItemSpacing: CGFloat = 16.0
    
    static let offset: CGFloat = 20.0 // TODO: for each side, define its offset
    static let offsetVert: CGFloat = 14.0
    
    static func getItemWidth(boundWidth: CGFloat) -> CGFloat {
        
        // totalCellWidth = (collectionview width or tableview width) - (left offset + right offset) - (total space x space width)
        let totalWidth = boundWidth - (offset + offset) - ((column - 1) * minItemSpacing)
        
        return totalWidth / column
    }
}

class HomeViewController: BaseViewController,
                        UITableViewDataSource, UITableViewDelegate,
                        UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,
                        CLLocationManagerDelegate {

    @IBOutlet weak var mLblTitle: UILabel!
    @IBOutlet weak var mSwitch: UISwitch!
    @IBOutlet weak var mTableView: UITableView!
    
    let locationManager = CLLocationManager()
    
    let TAG_CV_USER_WINK = 1000
    let TAG_CV_USER_MESSAGE = 1001
    
    private let CELLID_USER = "UserCell"
    
    var usersWink: [Message] = []
    var usersMessage: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mLblTitle.font = SHTextHelper.lobster13Regular(size: 20)
        mSwitch.transform = CGAffineTransform(scaleX: 0.7, y: 0.7);
        self.title = " "
        
        //
        // init location
        //
        self.locationManager.requestWhenInUseAuthorization()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.startUpdatingLocation()
        
        //
        // init data
        //
        for _ in 1...10 {
            usersWink.append(Message())
        }
        
        for i in 1...30 {
            let m = Message()
            if i < 10 {
                m.read = false
            }
            usersMessage.append(m)
        }
        
        mTableView.register(UINib(nibName: "HomeUserCell", bundle: nil), forCellReuseIdentifier: CELLID_USER)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideNavbar(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func gotoTabbarController(index: Int) {
        let storyboard = UIStoryboard(name: "Tab", bundle: nil)
        let tabbarController = storyboard.instantiateViewController(withIdentifier: "tabbarController") as! MainTabbarController
        tabbarController.selectedIndex = index
        
        self.navigationController?.setViewControllers([tabbarController], animated: true)
    }
    
    @IBAction func onButSetting(_ sender: Any) {
        // go to settings page
        gotoTabbarController(index: 3)
    }
    
    @IBAction func onButScan(_ sender: Any) {
        // go to map page
        gotoTabbarController(index: 1)
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
    // MARK: - UITableViewDataSource
    //
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // user for default
        var cellItem: UITableViewCell?
        
        if indexPath.row == 0 {
            // wink title
            if cellItem == nil {
                let nib = Bundle.main.loadNibNamed("HomeWinkTitleCell", owner: self, options: nil)
                cellItem = nib?[0] as? UITableViewCell
            }
        }
        else if indexPath.row == 2 {
            // wink title
            if cellItem == nil {
                let nib = Bundle.main.loadNibNamed("HomeMessageTitleCell", owner: self, options: nil)
                cellItem = nib?[0] as? UITableViewCell
            }
        }
        else {
            // user cell
            let cellUser = tableView.dequeueReusableCell(withIdentifier: CELLID_USER) as? HomeUserCell
            
            // init collection view
            let cv = cellUser?.collectionView
            
            cv?.tag = indexPath.row == 1 ? TAG_CV_USER_WINK : TAG_CV_USER_MESSAGE
            if let layout = cv?.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = indexPath.row == 1 ? .horizontal : .vertical
            }

            cv?.dataSource = self
            cv?.delegate = self
            
            // register nib
            cv?.register(UINib(nibName: "HomeUserCollectionCell", bundle: nil), forCellWithReuseIdentifier: "UserCollectionCell")
            
            cellItem = cellUser
        }
        
        return cellItem!
    }
    
    private func getItemsHeight(rowCount: Int) -> CGFloat {
        let itemHeight = HomeConstantCV.getItemWidth(boundWidth: view.bounds.size.width)
        let totalTopBottomOffset = HomeConstantCV.offsetVert + HomeConstantCV.offsetVert
        
        let totalSpacing = CGFloat(rowCount - 1) * HomeConstantCV.minLineSpacing
        let totalHeight  = ((itemHeight * CGFloat(rowCount)) + totalTopBottomOffset + totalSpacing)
        
        return totalHeight
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 1:
            // wink user
            return getItemsHeight(rowCount: 1)
            
        case 3:
            // messaged users
            let totalRow = ceil(CGFloat(usersMessage.count) / HomeConstantCV.column)
            return getItemsHeight(rowCount: Int(totalRow))
            
        default:
            return UITableViewAutomaticDimension
        }
    }

    //
    // MARK: - UICollectionViewDataSource
    //
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == TAG_CV_USER_WINK {
            return usersWink.count
        }
        else {
            return usersMessage.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellItem = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCollectionCell", for: indexPath) as! HomeUserCollectionCell
        
        // fill content
        if collectionView.tag == TAG_CV_USER_WINK {
            cellItem.fillContent(data: usersWink[indexPath.row])
        }
        else {
            cellItem.fillContent(data: usersMessage[indexPath.row])
        }
        
        return cellItem
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = HomeConstantCV.getItemWidth(boundWidth: collectionView.bounds.size.width)
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // go to profile page
        let profileVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        profileVC.mUser = User()
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    //
    // MARK: - CLLocationManagerDelegate
    //
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else { return }
        
//        thisUser?.location = location
        print("\(location.coordinate.latitude) \(location.coordinate.longitude)")
        
//        thisUser?.update(location: location, completion: { (error) in
//            //ignore error message here
//        })
    }
}
