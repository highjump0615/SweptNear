//
//  ChatViewController.swift
//  SweptUp
//
//  Created by Administrator on 6/18/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding
import Firebase

class ChatViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    var messages: [Message] = []
    
    var mUser: User?
    var mChat: Chat?
    var mViewReport: ProfilePopupReport?
    
    var mDbRef: DatabaseReference?
    var mKeyboardHeight: CGFloat = 0.0
    
    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var mViewInput: UIView!
    @IBOutlet weak var mTextField: UITextField!
    
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
        
        // keyboard avoiding
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(notification:)), name: .UIKeyboardWillShow, object: nil)
        
        showNavbar()
        
        // init report user popup view
        mViewReport = ProfilePopupReport.getView(user: mUser) as? ProfilePopupReport
        self.view.addSubview(mViewReport!)
        
        //
        // init data
        //
        fetchChat()
        
        getMessages()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // title
        self.title = "Chat"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func getKeyboardHeight(notification: NSNotification?) -> CGFloat {
        guard let keyboardFrame = notification?.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return 0
        }
        
        let keyboardHeight: CGFloat
        if #available(iOS 11.0, *) {
            keyboardHeight = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom
        } else {
            keyboardHeight = keyboardFrame.cgRectValue.height
        }
        
        return keyboardHeight
    }
    
    @objc
    func keyboardWillAppear(notification: NSNotification?) {
        if mKeyboardHeight > 0 {
            // already showing keyboard, return
            return
        }

        var frmView = self.view.frame
        mKeyboardHeight = getKeyboardHeight(notification: notification)
        frmView.size = CGSize(width: frmView.width, height: frmView.height - mKeyboardHeight)
        
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.view.frame = frmView
        }) { (finished) in
            self.tableViewScrollToBottom(animated: false)
        }
    }
    
    func keyboardWillDisappear() {
        var frmView = self.view.frame
        frmView.size = CGSize(width: frmView.width, height: frmView.height + mKeyboardHeight)
        
        UIView.animate(withDuration: 0.3,
                       animations: {
                        self.view.frame = frmView
        })
        
        mKeyboardHeight = 0
    }
    
    func fetchChat() {
        let userCurrent = User.currentUser!
        
        if mChat != nil {
            // already fetched, return
            mChat?.markRead(withID: self.mUser!.id, parentId: userCurrent.id)
            return
        }
        
        // fetch chat room
        let db = FirebaseManager.ref().child(Chat.TABLE_NAME).child(userCurrent.id).child(mUser!.id)
        db.observeSingleEvent(of: .value) { (snapshot) in
            if !snapshot.exists() {
                return
            }
            
            self.mChat = Chat(snapshot: snapshot)
            // mark chat read
            self.mChat?.markRead(withID: self.mUser!.id, parentId: userCurrent.id)
        }
    }
    
    func getMessages() {
        let userCurrent = User.currentUser!
        
        self.messages.removeAll()
        
        mDbRef = FirebaseManager.ref().child(Message.TABLE_NAME).child(userCurrent.id).child(mUser!.id)
        mDbRef?.observe(.childAdded, with: { (snapshot) in
            let msg = Message(snapshot: snapshot)
            msg.id = snapshot.key
            
            // set user
            msg.sender = msg.senderId == userCurrent.id ? userCurrent : self.mUser
            
            var isExist = false
            for aMsg in self.messages {
                if aMsg.isEqual(to: msg) {
                    isExist = true
                    break
                }
            }

            if !isExist {
                DispatchQueue.main.async {
                    self.messages.append(msg)
                    
                    self.updateTable()
                }
            }
        })
    }
    
    @objc func onButReport() {
        // show report view
        mViewReport?.frame = self.view.bounds
        mViewReport?.showView(bShow: true, animated: true)
    }
    
    @IBAction func onButSend(_ sender: Any) {
        self.view.endEditing(true)

        // send
        let text = mTextField.text!
        if text.isEmpty {
            return
        }
        
        //
        // update chat info
        //
        let userCurrent = User.currentUser!
        if mChat == nil {
            mChat = Chat()
        }
        mChat?.senderId = userCurrent.id
        mChat?.text = text
        
        mChat?.saveToDatabase(withID: mUser?.id, parentID: userCurrent.id)
        mChat?.saveToDatabase(withID: userCurrent.id, parentID: mUser?.id)
        
        // add new mesage
        let msgNew = Message()
        msgNew.senderId = userCurrent.id
        msgNew.sender = userCurrent
        msgNew.text = text
        
        var strKey = "\(mUser!.id)/\(userCurrent.id)"
        msgNew.saveToDatabase(withID: nil, parentID: strKey)
        
        strKey = "\(userCurrent.id)/\(mUser!.id)"
        msgNew.saveToDatabase(withID: nil, parentID: strKey)
        
        self.messages.append(msgNew)
        
        // clear textfield
        self.mTextField.text = ""
        
        // update table
        updateTable()
        
        // send notification to user
        Notification.sendPushNotification(receiver: mUser!,
                                          message: text,
                                          title: userCurrent.userFullName())
    }
    
    func updateTable(animated: Bool = false) {
        if animated {
            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
            mTableView.insertRows(at: [indexPath], with: .automatic)
        }
        else {
            mTableView.reloadData()
        }
        
        self.tableViewScrollToBottom(animated: false)
    }
    
    func tableViewScrollToBottom(animated: Bool) {
        let time = animated ? 300 : 0
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(time)) {
            
            if self.mTableView.contentSize.height > self.mTableView.frame.size.height {
                let bottomOffset = CGPoint(x: 0,
                                           y: self.mTableView.contentSize.height - self.mTableView.frame.size.height)
                self.mTableView.setContentOffset(bottomOffset, animated: true)
            }
        }
    }
    
    /// go to user profile
    @objc func onButUser(sender: UIButton) {
        let profileVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        profileVC.mUser = messages[sender.tag].sender
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
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let msg = messages[indexPath.row]
        let userCurrent = User.currentUser!
        
        var strCellId = "ChatFromCell"
        if msg.senderId == userCurrent.id {
            strCellId = "ChatToCell"
        }
            
        let cellItem = tableView.dequeueReusableCell(withIdentifier: strCellId) as! ChatCell
        cellItem.backgroundColor = UIColor.clear
        cellItem.fillContent(msg: msg)
        
        cellItem.mButUser.tag = indexPath.row
        cellItem.mButUser.addTarget(self, action: #selector(onButUser), for: .touchUpInside)

        return cellItem
    }
}

extension ChatViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        onButSend(mTextField)
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        keyboardWillDisappear()
        
        return true
    }
}
