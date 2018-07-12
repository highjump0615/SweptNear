//
//  NoticiationViewController.swift
//  SweptUp
//
//  Created by Administrator on 6/17/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit
import Firebase

class NotificationViewController: UITableViewController {
    
    var notifications: [Notification] = []
    
    var mDbRef: DatabaseReference?

    override func viewDidLoad() {
        super.viewDidLoad()

        // hide empty cells
        tableView.tableFooterView = UIView()
        
        tableView.emptyDataSetView { (view) in
            view.titleLabelString(Utils.getAttributedString(text: "No notifications yet"))
                .verticalOffset(-100)
                .shouldDisplay(true)
                .shouldFadeIn(true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // title
        self.tabBarController?.navigationItem.title = "Notifications"
        
        //
        // init data
        //
        getNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        mDbRef?.removeAllObservers()
    }
    
    func getNotifications() {
        let userCurrent = User.currentUser!
        self.notifications.removeAll()
        
        mDbRef = FirebaseManager.ref().child(Notification.TABLE_NAME).child(userCurrent.id)
        
        var nFetchCount = 0
        var nFetchUserCount = 0
        
        mDbRef?.observe(.childAdded) { (snapshot) in
            if !snapshot.exists() {
                return
            }
            
            let nn = Notification(snapshot: snapshot)
            nFetchCount += 1
            
            self.notifications.append(nn)
            
            // set user related
            User.readFromDatabase(withId: nn.senderId, completion: { (user) in
                nFetchUserCount += 1
                
                nn.sender = user
                
                // update table
                if nFetchCount == nFetchUserCount {
                    self.tableView.reloadData()
                }
            })
        }
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
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellMsg = tableView.dequeueReusableCell(withIdentifier: "NotificationListCell") as! NotificationListCell
        cellMsg.fillContent(data: notifications[indexPath.row])
        
        return cellMsg
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    //
    // MARK: - UITableViewDelegate
    //
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // winks
        let notify = notifications[indexPath.row]
        
        if notify.type == Notification.TYPE_WINK || notify.type == Notification.TYPE_WINK_BACK {
            // go to profile page
            let profileVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
            profileVC.mUser = notify.sender
            self.navigationController?.pushViewController(profileVC, animated: true)
        }
    }

}
