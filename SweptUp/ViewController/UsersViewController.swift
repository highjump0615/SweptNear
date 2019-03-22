//
//  UsersViewController.swift
//  SweptUp
//
//  Created by Administrator on 10/11/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit
import Firebase

class UsersViewController: BaseUsersViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mTableView.emptyDataSetView { (view) in
            view.titleLabelString(Utils.getAttributedString(text: "No blocked users yet"))
                .verticalOffset(-100)
                .shouldDisplay(true)
                .shouldFadeIn(true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Blocked Users"
        
        getUserInfo(bRefresh: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.title = " "
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// query blocked users
    ///
    /// - Parameter bRefresh: <#bRefresh description#>
    override func getUserInfo(bRefresh: Bool) {
        let userCurrent = User.currentUser!
        
        // clear list
        self.users.removeAll()
        
        // no blocked user
        if userCurrent.usersBlocked.isEmpty {
            self.updateTable()
        }
        
        var nFetchCount = 0
        
        // parse userid
        for userId in userCurrent.usersBlocked {
            // get user info
            User.readFromDatabase(withId: userId, completion: { (user) in
                nFetchCount += 1
                
                if let user = user {
                    self.users.append(user)
                }
                
                // update table
                if nFetchCount == userCurrent.usersBlocked.count {
                    self.updateTable()
                }
            })
        }
    }
    
    func updateTable() {
        self.stopRefreshing()
        self.mTableView.reloadData()
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
