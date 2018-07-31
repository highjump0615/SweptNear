//
//  HomeViewController.swift
//  SweptUp
//
//  Created by Administrator on 6/14/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

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
                        UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var mLblTitle: UILabel!
    @IBOutlet weak var mSwitch: UISwitch!
    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var mButProfile: UIButton!
    
    let TAG_CV_USER_WINK = 1000
    let TAG_CV_USER_MESSAGE = 1001
    
    private let CELLID_USER = "UserCell"
    
    var winks: [Wink] = []
    var chats: [Chat] = []
    
    var mRefreshControl: UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //
        // init controls
        //
        mLblTitle.font = SHTextHelper.lobster13Regular(size: 20)
        mSwitch.transform = CGAffineTransform(scaleX: 0.7, y: 0.7);
        self.title = " "
        mButProfile.makeRound()
        
        initLocation()
        
        //
        // init table view
        //
        mTableView.register(UINib(nibName: "HomeUserCell", bundle: nil), forCellReuseIdentifier: CELLID_USER)
        
        mRefreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        mTableView.addSubview(mRefreshControl)
        
        // update user info
        updateUserInfo()
        
        //
        // init data
        //
        getMainInfo(bRefresh: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideNavbar(animated: true)
        
        // update data
        winks = winks.filter{$0.status == WinkStatus.waiting}
        
        mTableView.reloadData()
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
    
    /// fetch photos from user
    ///
    /// - Parameter bRefresh: <#bRefresh description#>
    func getMainInfo(bRefresh: Bool) {
        if !bRefresh {
            // show refreshing indicator manually
            self.mTableView.contentOffset = CGPoint(x: 0, y: -self.mRefreshControl.frame.size.height);
            mRefreshControl.beginRefreshing()
        }
        
        let userCurrent = User.currentUser!
        let winkRef = FirebaseManager.ref().child(Wink.TABLE_NAME).child(userCurrent.id)
        let query = winkRef.queryOrdered(byChild: Wink.FIELD_STATUS).queryEqual(toValue: WinkStatus.waiting.rawValue)
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            // notifications not found
            if !snapshot.exists() {
                self.stopRefreshing()
                
                self.getMessages()
                return
            }
            
            // clear list
            self.winks.removeAll()
            var nFetchCount = 0
            
            // parse wink
            for wink in snapshot.children {
                let w = Wink(snapshot: wink as! DataSnapshot)
                self.winks.append(w)
                
                // fetch user
                User.readFromDatabase(withId: w.senderId, completion: { (user) in
                    w.sender = user
                    
                    nFetchCount += 1
                    if nFetchCount == self.winks.count {
                        self.getMessages()
                    }
                })
            }
        })
    }
    
    func getMessages() {
        let userCurrent = User.currentUser!
        let msgRef = FirebaseManager.ref().child(Chat.TABLE_NAME).child(userCurrent.id)
        msgRef.observeSingleEvent(of: .value, with: { (snapshot) in
            // msg not found
            if !snapshot.exists() {
                self.stopRefreshing()
                return
            }
            
            // clear list
            self.chats.removeAll()
            var nFetchCount = 0
            
            // parse messages
            for msg in snapshot.children {
                let c = Chat(snapshot: msg as! DataSnapshot)
                
                // only add received message
                if c.senderId == userCurrent.id {
                    continue
                }
                self.chats.append(c)
                
                // fetch user
                User.readFromDatabase(withId: c.senderId, completion: { (user) in
                    c.sender = user
                    
                    nFetchCount += 1
                    if nFetchCount == self.chats.count {
                        self.stopRefreshing()
                    }
                })
            }
            
            if self.chats.isEmpty {
                self.stopRefreshing()
            }
        })
    }
    
    /// refresh table
    ///
    /// - Parameter sender: <#sender description#>
    @objc func refresh(sender: Any) {
        getMainInfo(bRefresh: true)
    }
    
    func stopRefreshing() {
        self.mRefreshControl.endRefreshing()
        perform(#selector(reloadTable), with: nil, afterDelay: 0.4)
    }
    
    @objc func reloadTable(sender: Any) {
        self.mTableView.reloadData()
    }
    
    @IBAction func onButSetting(_ sender: Any) {
        // go to settings page
        gotoTabbarController(index: 3)
    }
    
    @IBAction func onButScan(_ sender: Any) {
        // go to map page
        gotoTabbarController(index: 1)
    }
    
    /// switch for availability has changed
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func onSwitchChanged(_ sender: Any) {
        let user = User.currentUser!
        
        user.available = mSwitch.isOn
        user.saveToDatabase(withField: User.FIELD_AVAILABLE, value: user.available)
    }
    
    /// update current user info
    func updateUserInfo() {
        let user = User.currentUser!
        
        // photo
        if let photoUrl = user.photoUrl {
            mButProfile.sd_setImage(with: URL(string: photoUrl),
                                    for: .normal,
                                    placeholderImage: UIImage(named: "UserDefault"),
                                    options: .progressiveDownload,
                                    completed: nil)
        }
        
        // availability
        mSwitch.setOn(user.available, animated: true)
    }
    
    @IBAction func onButProfile(_ sender: Any) {
        // go to profile page
        let profileVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        profileVC.mUser = User.currentUser
        self.navigationController?.pushViewController(profileVC, animated: true)
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
                let cellTitle = nib?[0] as? HomeTitleCell
                cellTitle?.mLblCount.text = String(winks.count)
                
                cellItem = cellTitle
            }
        }
        else if indexPath.row == 2 {
            // message title
            if cellItem == nil {
                let nib = Bundle.main.loadNibNamed("HomeMessageTitleCell", owner: self, options: nil)
                let cellTitle = nib?[0] as? HomeTitleCell
                cellTitle?.mLblCount.text = String(chats.filter({$0.isRead() == false}).count)
                
                cellItem = cellTitle
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
            
            let strNotice = indexPath.row == 1 ? "No winks received yet" : "No messages received yet"
            cv?.emptyDataSetView { (view) in
                view.titleLabelString(Utils.getAttributedString(text: strNotice))
                    .shouldDisplay(true)
                    .shouldFadeIn(true)
            }

            cv?.dataSource = self
            cv?.delegate = self
            
            // register nib
            cv?.register(UINib(nibName: "HomeUserCollectionCell", bundle: nil), forCellWithReuseIdentifier: "UserCollectionCell")
            cv?.reloadData()
            
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
            let totalRow = max(ceil(CGFloat(chats.count) / HomeConstantCV.column), 1)
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
            return winks.count
        }
        else {
            return chats.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellItem = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCollectionCell", for: indexPath) as! HomeUserCollectionCell
        
        // fill content
        if collectionView.tag == TAG_CV_USER_WINK {
            cellItem.fillContent(data: winks[indexPath.row])
        }
        else {
            cellItem.fillContent(data: chats[indexPath.row])
        }
        
        return cellItem
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = HomeConstantCV.getItemWidth(boundWidth: collectionView.bounds.size.width)
        
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == TAG_CV_USER_WINK {
            // go to profile page
            let profileVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
            profileVC.mWink = winks[indexPath.row]
            profileVC.mUser = winks[indexPath.row].sender
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
        else {
            // go to chat page
            let chatVC = ChatViewController(nibName: "ChatViewController", bundle: nil)
            chatVC.mUser = chats[indexPath.row].sender
            chatVC.mChat = chats[indexPath.row]
            self.navigationController?.pushViewController(chatVC, animated: true)
        }
    }
}
