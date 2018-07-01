//
//  ChatListViewController.swift
//  SweptUp
//
//  Created by Administrator on 6/17/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift

class ChatListViewController: UITableViewController {
    
    var messages: [Message] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        //
        // init data
        //
        getChatListInfo()
        
        // hide empty cells
        tableView.tableFooterView = UIView()
        
        tableView.emptyDataSetView { (view) in
            view.titleLabelString(Utils.getAttributedString(text: "No messages yet"))
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
        self.tabBarController?.navigationItem.title = "Messages"
    }
    
    func getChatListInfo() {
        let userCurrent = User.currentUser!
        
        let chatRef = FirebaseManager.ref().child(Chat.TABLE_NAME)
        let query = chatRef.queryOrderedByKey().queryEqual(toValue: userCurrent.id)
        
        query.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.exists() {
            }
//
//            self.stopRefreshing()
//            self.mTableView.reloadData()
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
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellMsg = tableView.dequeueReusableCell(withIdentifier: "ChatListCell")        
        
        return cellMsg!
    }
    
    //
    // MARK: - UITableViewDelegate
    //
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // go to chat page
        let chatVC = ChatViewController(nibName: "ChatViewController", bundle: nil)
        self.navigationController?.pushViewController(chatVC, animated: true)
    }

}
