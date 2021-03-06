//
//  SettingsViewController.swift
//  SweptUp
//
//  Created by Administrator on 6/17/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // hide empty cells
        self.tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // title
        if User.currentUser?.type == User.USER_TYPE_ADMIN {
            self.title = "Settings"
        }
        self.tabBarController?.navigationItem.title = "Settings"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // title
        if User.currentUser?.type == User.USER_TYPE_ADMIN {
            self.title = " "
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
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let userCurrent = User.currentUser
        
        switch indexPath.row {
        case 0:
            if userCurrent?.type == User.USER_TYPE_ADMIN {
                // go to admin edit profile page
                let profileVC = AdminEditProfileViewController(nibName: "AdminEditProfileViewController", bundle: nil)
                self.navigationController?.pushViewController(profileVC, animated: true)
            }
            else {
                // go to profile page
                let profileVC = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
                self.navigationController?.pushViewController(profileVC, animated: true)
            }
            
        case 1:
            if userCurrent?.type == User.USER_TYPE_ADMIN {
                // log out
                doSignOut()
            }
            else {
                // rate the app
                Utils.rateApp(appId: Config.appId, completion: { (_) in
                })
            }
            
        case 2:
            // Send feedback
            if !MFMailComposeViewController.canSendMail() {
                alertOk(title: "Mail", message: "Mail services are not available", cancelButton: "OK", cancelHandler: nil)
                return
            }
            
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            
            // Configure the fields of the interface.
            composeVC.setToRecipients(["jameso1777@yahoo.com"])
            composeVC.setSubject("Report a bug")
            composeVC.setMessageBody("", isHTML: false)
            
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
            
        case 3:
            // go to about page
            let aboutVC = AboutViewController(nibName: "AboutViewController", bundle: nil)
            self.navigationController?.pushViewController(aboutVC, animated: true)
            
        case 4:
            // go to privacy page
            let termVC = TermsViewController(nibName: "TermsViewController", bundle: nil)
            termVC.type = TermsViewController.PRIVACY_POLICY
            self.navigationController?.pushViewController(termVC, animated: true)
            
        case 5:
            // go to terms & conditions page newly
            let termVC = TermsViewController(nibName: "TermsViewController", bundle: nil)
            termVC.type = TermsViewController.TERMS_FROM_SETTING
            self.navigationController?.pushViewController(termVC, animated: true)
            
        case 6:
            // go to blocked users page
            let usersVC = UsersViewController(nibName: "UsersViewController", bundle: nil)
            self.navigationController?.pushViewController(usersVC, animated: true)
            
        case 7:
            doSignOut()
            
        default:
            break
        }
    }
    
    private func doSignOut() {
        FirebaseManager.signOut()
        User.currentUser = nil
        
        // go to sign in page
        let signinVC = SigninViewController(nibName: "SigninViewController", bundle: nil)
        self.navigationController?.setViewControllers([signinVC], animated: true)
    }
}

extension SettingsViewController : MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        // Check the result or perform other tasks.
        
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
}

