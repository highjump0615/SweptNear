//
//  AdminUsersViewController.swift
//  SweptUp
//
//  Created by Administrator on 7/30/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit
import Firebase

class AdminUsersViewController: BaseViewController {
    
    static let USER_ALL = 0
    static let USER_BANNED = 1
    
    var users: [User] = []
    
    var mnType = AdminUsersViewController.USER_ALL

    @IBOutlet weak var mButAll: UIButton!
    @IBOutlet weak var mButBanned: UIButton!
    @IBOutlet weak var mCstUnderline: NSLayoutConstraint!
    
    @IBOutlet weak var mTableView: UITableView!
    var mRefreshControl: UIRefreshControl = UIRefreshControl()
    
    private let CELLID_USER = "UserCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //
        // init table view
        //
        mTableView.register(UINib(nibName: "AdminUserCell", bundle: nil), forCellReuseIdentifier: CELLID_USER)
        // hide empty cells
        mTableView.tableFooterView = UIView()
        // add refresh control
        mRefreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        mTableView.addSubview(mRefreshControl)
        
        setQueryType(type: AdminUsersViewController.USER_ALL)
        getUserInfo(bRefresh: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Users"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.title = " "
    }
    
    @IBAction func onButAll(_ sender: Any) {
        mButAll.setTitleColor(UIColor.white, for: .normal)
        mButBanned.setTitleColor(UIColor.lightGray, for: .normal)
        
        setQueryType(type: AdminUsersViewController.USER_ALL)
    }
    
    @IBAction func onButBanned(_ sender: Any) {
        mButBanned.setTitleColor(UIColor.white, for: .normal)
        mButAll.setTitleColor(UIColor.lightGray, for: .normal)
        
        setQueryType(type: AdminUsersViewController.USER_BANNED)
    }
    
    /// refresh table
    ///
    /// - Parameter sender: <#sender description#>
    @objc func refresh(sender: Any) {
        getUserInfo(bRefresh: true)
    }
    
    func getUserInfo(bRefresh: Bool) {
        if !bRefresh {
            // show refreshing indicator manually
            self.mTableView.contentOffset = CGPoint(x: 0, y: -self.mRefreshControl.frame.size.height);
            mRefreshControl.beginRefreshing()
        }
        
        let userRef = FirebaseManager.ref().child(User.TABLE_NAME)
        let query = mnType == AdminUsersViewController.USER_ALL
            ? userRef
            : userRef.queryOrdered(byChild: User.FIELD_BANNED).queryEqual(toValue: true )
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            self.stopRefreshing()
            
            // clear list
            self.users.removeAll()
            
            // users not found
            if !snapshot.exists() {
                self.mTableView.reloadData()
                return
            }
            
            // parse wink
            for user in snapshot.children {
                let u = User(snapshot: user as! DataSnapshot)
                
                // except admin
                if u.type == User.USER_TYPE_ADMIN {
                    continue
                }
                
                self.users.append(u)
            }

            self.mTableView.reloadData()
        })
    }
    
    func stopRefreshing() {
        self.mRefreshControl.endRefreshing()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setQueryType(type: Int) {
        let strNotice = type == AdminUsersViewController.USER_ALL ? "No users yet" : "No banned users yet"
        mTableView.emptyDataSetView { (view) in
            view.titleLabelString(Utils.getAttributedString(text: strNotice))
                .verticalOffset(-100)
                .shouldDisplay(true)
                .shouldFadeIn(true)
        }
        
        if type == mnType {
            return
        }
        
        mnType = type
        self.getUserInfo(bRefresh: true)
        
        let screenWidth = UIScreen.main.bounds.width
        UIView.animate(withDuration: 0.2,
                       animations: {
                        self.mCstUnderline.constant = CGFloat(self.mnType) * screenWidth / 2
                        self.view.layoutIfNeeded()
        }) { (finished) in
        }
    }

}

extension AdminUsersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = users[indexPath.row]
        
        let cellItem = tableView.dequeueReusableCell(withIdentifier: CELLID_USER) as! AdminUserCell
        cellItem.fillContent(user: user)
        
        return cellItem
    }
}

extension AdminUsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let profileVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        profileVC.mUser = users[indexPath.row]
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
}
