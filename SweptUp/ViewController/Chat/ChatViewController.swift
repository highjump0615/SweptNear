//
//  ChatViewController.swift
//  SweptUp
//
//  Created by Administrator on 6/18/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit

class ChatViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    var messages: [Message] = []
    
    @IBOutlet weak var mTableView: UITableView!
    
    private let CELLID_CHAT_TO = "ChatToCell"
    private let CELLID_CHAT_FROM = "ChatFromCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // right bar button
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ChatReport"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(onButReport))
        
        // init tableview
        mTableView.register(UINib(nibName: "ChatToCell", bundle: nil), forCellReuseIdentifier: CELLID_CHAT_TO)
        mTableView.register(UINib(nibName: "ChatFromCell", bundle: nil), forCellReuseIdentifier: CELLID_CHAT_FROM)
        
        mTableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 0, right: 0)
        
        //
        // init data
        //
        for i in 1...4 {
            let m = Message()
            if i % 2 == 0 {
                m.userFrom = User()
            }
            messages.append(m)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // title
        self.title = "Chat"
    }
    
    @objc func onButReport() {
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
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let msg = messages[indexPath.row]
        
        var strCellId = "ChatFromCell"
        if msg.userFrom == nil {
            strCellId = "ChatToCell"
        }
            
        let cellItem = tableView.dequeueReusableCell(withIdentifier: strCellId) as! ChatCell
        cellItem.backgroundColor = UIColor.clear

        return cellItem
    }
    
}
