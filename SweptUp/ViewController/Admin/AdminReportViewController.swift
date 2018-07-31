//
//  AdminReportViewController.swift
//  SweptUp
//
//  Created by Administrator on 7/31/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit
import Firebase

class AdminReportViewController: BaseViewController {
    
    var reports: [Report] = []
    
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
        
        mTableView.emptyDataSetView { (view) in
            view.titleLabelString(Utils.getAttributedString(text: "No reported users yet"))
                .verticalOffset(-100)
                .shouldDisplay(true)
                .shouldFadeIn(true)
        }
        
        getReportInfo(bRefresh: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "Reported Users"
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

    /// refresh table
    ///
    /// - Parameter sender: <#sender description#>
    @objc func refresh(sender: Any) {
        getReportInfo(bRefresh: true)
    }
    
    func getReportInfo(bRefresh: Bool) {
        if !bRefresh {
            // show refreshing indicator manually
            self.mTableView.contentOffset = CGPoint(x: 0, y: -self.mRefreshControl.frame.size.height);
            mRefreshControl.beginRefreshing()
        }
        
        var nFetchCount = 0
        var nFetchUserCount = 0
        
        let query = FirebaseManager.ref().child(Report.TABLE_NAME)
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            self.stopRefreshing()
            
            // clear list
            self.reports.removeAll()
            
            // users not found
            if !snapshot.exists() {
                self.mTableView.reloadData()
                return
            }
            
            for reportUser in snapshot.children {
                let reports = reportUser as! DataSnapshot
                
                for report in reports.children {
                    let r = Report(snapshot: report as! DataSnapshot)
                    
                    nFetchCount += 1
                    
                    // set user related
                    User.readFromDatabase(withId: reports.key, completion: { (user) in
                        nFetchUserCount += 1
                        
                        r.user = user
                        self.reports.append(r)
                        
                        // update table
                        if nFetchCount == nFetchUserCount {
                            self.mTableView.reloadData()
                        }
                    })
                    
                    break
                }
            }
            
            if nFetchCount == 0 {
                self.mTableView.reloadData()
            }
        })
    }
    
    func stopRefreshing() {
        self.mRefreshControl.endRefreshing()
    }
}

extension AdminReportViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reports.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let report = reports[indexPath.row]
        
        let cellItem = tableView.dequeueReusableCell(withIdentifier: CELLID_USER) as! AdminUserCell
        cellItem.fillContent(user: report.user!)
        
        return cellItem
    }
}

extension AdminReportViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let reportDetailVC = AdminReportDetailViewController(nibName: "AdminReportDetailViewController", bundle: nil)
        reportDetailVC.mReport = reports[indexPath.row]
        self.navigationController?.pushViewController(reportDetailVC, animated: true)
    }
}

