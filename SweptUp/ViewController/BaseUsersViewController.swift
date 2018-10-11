//
//  BaseUsersViewController.swift
//  SweptUp
//
//  Created by Administrator on 10/11/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit

class BaseUsersViewController: UIViewController {
    
    var users: [User] = []
    
    @IBOutlet weak var mTableView: UITableView!
    var mRefreshControl: UIRefreshControl = UIRefreshControl()
    
    let CELLID_USER = "UserCell"

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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// refresh table
    ///
    /// - Parameter sender: <#sender description#>
    @objc func refresh(sender: Any) {
        getUserInfo(bRefresh: true)
    }
    
    /// virtual func
    ///
    /// - Parameter bRefresh: <#bRefresh description#>
    func getUserInfo(bRefresh: Bool) {
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

}

extension BaseUsersViewController: UITableViewDataSource {
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

extension BaseUsersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let profileVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        profileVC.mUser = users[indexPath.row]
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
}

