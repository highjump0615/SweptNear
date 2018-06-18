//
//  ChatListViewController.swift
//  SweptUp
//
//  Created by Administrator on 6/17/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit

class ChatListViewController: UITableViewController {
    
    var messages: [Message] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        //
        // init data
        //
        for _ in 1...3 {
            messages.append(Message())
        }
        
        // hide empty cells
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // title
        self.tabBarController?.navigationItem.title = "Messages"
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
