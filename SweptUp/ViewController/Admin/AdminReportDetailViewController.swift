//
//  AdminReportDetailViewController.swift
//  SweptUp
//
//  Created by Administrator on 7/31/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit
import SVProgressHUD

class AdminReportDetailViewController: BaseViewController {
    
    var mReport: Report?
    
    @IBOutlet weak var mLblDesc: UILabel!
    @IBOutlet weak var mButReporter: UIButton!
    @IBOutlet weak var mButDelete: UIButton!
    @IBOutlet weak var mButBan: UIButton!
    
    @IBOutlet weak var mViewReporter: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mLblDesc.text = mReport?.description
        
        // fetch reporter user
        // set user related
        User.readFromDatabase(withId: mReport!.senderId, completion: { (user) in
            self.mReport?.sender = user
            
            self.mButReporter.setTitle(user?.userFullName(), for: .normal)
            self.mViewReporter.isHidden = false
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        mButDelete.makeRound()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = mReport?.user?.userFullName()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.title = " "
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func onButDelete(_ sender: Any) {
        // delete report
        let database = FirebaseManager.ref().child(Report.TABLE_NAME)
        database.child((mReport?.user?.id)!).child(mReport!.id).removeValue()
        
        // update report list
        let prevVC = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 2] as! AdminReportViewController
        prevVC.getReportInfo(bRefresh: false)
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onButBan(_ sender: Any) {
        if let user = mReport?.user, !user.banned {
            user.banned = true
            user.saveToDatabase(withField: User.FIELD_BANNED, value: true)

            // show notice
            SVProgressHUD.setContainerView(self.view)
            SVProgressHUD.setDefaultMaskType(.gradient)
            SVProgressHUD.showSuccess(withStatus: "Banned user successfully")
        }
    }
    
    @IBAction func onButReporter(_ sender: Any) {
        // go to profile page
        let profileVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
        profileVC.mUser = mReport?.sender
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    
    
}
