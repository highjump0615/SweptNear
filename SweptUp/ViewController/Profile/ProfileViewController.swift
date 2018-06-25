//
//  ProfileViewController.swift
//  SweptUp
//
//  Created by Administrator on 6/18/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit

class ProfileConstantCV {
    static let column: CGFloat = 3
    
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

class ProfileViewController: BaseViewController,
                            UITableViewDataSource, UITableViewDelegate,
                            UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var mUser: User?
    var mViewSent: ProfilePopupSent?
    
    @IBOutlet weak var mTableView: UITableView!
    
    private let CELLID_USER = "ProfileUserCell"
    private let CELLID_USER_PHOTO = "ProfileUserPhotoCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init user
        if mUser == nil {
            mUser = User.currentUser
        }

        // hide empty cells
        mTableView.tableFooterView = UIView()
        
        mTableView.register(UINib(nibName: "ProfileUserCell", bundle: nil), forCellReuseIdentifier: CELLID_USER)
        
        // right bar button
        if (mUser?.isEqual(to: User.currentUser!))! {
            // edit profile
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                                target: self,
                                                                action: #selector(onButEdit))
        }
        else {
            // report
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ChatReport"),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(onButReport))
        }
        
        showNavbar()
        
        mViewSent = ProfilePopupSent.getView() as? ProfilePopupSent
        self.view.addSubview(mViewSent!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // title
        self.title = "Profile Information"
    }
    
    /// report user
    @objc func onButReport() {
    }
    
    /// edit profile
    @objc func onButEdit() {
        // go to signup profile page
        let signupProfileVC = SignupProfileViewController(nibName: "SignupProfileViewController", bundle: nil)
        signupProfileVC.type = SignupProfileViewController.FROM_PROFILE
        self.navigationController?.pushViewController(signupProfileVC, animated: true)
    }
    
    /// send wink
    @objc func onButSend() {
        mViewSent?.frame = self.view.bounds
        mViewSent?.showView(bShow: true, animated: true)
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellItem: UITableViewCell?
        
        if indexPath.row == 0 {
            // profile user
            let cellUser = tableView.dequeueReusableCell(withIdentifier: CELLID_USER) as? ProfileUserCell
            cellUser?.fillContent(user: mUser!)
            cellUser?.mButSend.addTarget(self, action: #selector(onButSend), for: .touchUpInside)
            
            cellItem = cellUser
        }
        else if indexPath.row == 1 {
            // photos
            if cellItem == nil {
                let nib = Bundle.main.loadNibNamed("ProfilePhotoCell", owner: self, options: nil)
                let cellPhoto = nib?[0] as? ProfilePhotoCell
                
                // init collection view
                let cv = cellPhoto?.mCollectionView
                cv?.dataSource = self
                cv?.delegate = self
                
                // register nib
                cv?.register(UINib(nibName: "ProfilePhotoCollectionCell", bundle: nil), forCellWithReuseIdentifier: CELLID_USER_PHOTO)
                
                cellItem = cellPhoto
            }
        }
        
        return cellItem!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var totalHeight = UITableViewAutomaticDimension
        
        if indexPath.row == 1 {
            let itemHeight = ProfileConstantCV.getItemWidth(boundWidth: view.bounds.size.width)
            let totalTopBottomOffset = ProfileConstantCV.offsetVert + HomeConstantCV.offsetVert
            
            let totalSpacing = 3 * ProfileConstantCV.minLineSpacing
            totalHeight = ((itemHeight * 3) + totalTopBottomOffset + totalSpacing)
        }

        return totalHeight
    }

    //
    // MARK: - UICollectionViewDataSource
    //
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellItem = collectionView.dequeueReusableCell(withReuseIdentifier: CELLID_USER_PHOTO, for: indexPath)
        
        return cellItem
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = ProfileConstantCV.getItemWidth(boundWidth: collectionView.bounds.size.width)
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
}
