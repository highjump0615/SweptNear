//
//  ChatListViewController.swift
//  SweptUp
//
//  Created by Administrator on 6/17/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit
import EmptyDataSet_Swift
import Firebase

class ChatListViewController: UITableViewController {
    
    var chats: [Chat] = []

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
        self.tabBarController?.navigationItem.title = "Messages"
    }
    
    func getChatListInfo() {
        let userCurrent = User.currentUser!
        
        let chatRef = FirebaseManager.ref().child(Chat.TABLE_NAME).child(userCurrent.id)
        
        var nFetchCount = 0
        var nFetchUserCount = 0

        chatRef.observe(.childAdded) { (snapshot) in
            if !snapshot.exists() {
                return
            }
            
            let chat = Chat(snapshot: snapshot)
            nFetchCount += 1
            
            self.chats.append(chat)
            
            // set user related
            User.readFromDatabase(withId: chat.id, completion: { (user) in
                nFetchUserCount += 1
                
                chat.userRelated = user
              
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
        return chats.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellMsg = tableView.dequeueReusableCell(withIdentifier: "ChatListCell") as! ChatListCell
        cellMsg.fillContent(chat: chats[indexPath.row])
        
        return cellMsg
    }
    
    //
    // MARK: - UITableViewDelegate
    //
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // go to chat page
        let chat = self.chats[indexPath.row]
        let chatVC = ChatViewController(nibName: "ChatViewController", bundle: nil)
        chatVC.mUser = chat.userRelated
        chatVC.mChat = chat
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
}
