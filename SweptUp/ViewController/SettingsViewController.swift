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
        self.tabBarController?.navigationItem.title = "Settings"
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
        
        switch indexPath.row {
        case 1:
            //rate the app
            Utils.rateApp(appId: Config.appId, completion: { (_) in
            })
            
        case 2:
            // Send feedback
            if !MFMailComposeViewController.canSendMail() {
                alertOk(title: "Mail", message: "Mail services are not available", cancelButton: "OK", cancelHandler: nil)
                return
            }
            
            let composeVC = MFMailComposeViewController()
            composeVC.mailComposeDelegate = self
            
            // Configure the fields of the interface.
            composeVC.setToRecipients(["support@impact.com"])
            composeVC.setSubject("Report a bug")
            composeVC.setMessageBody("", isHTML: false)
            
            // Present the view controller modally.
            self.present(composeVC, animated: true, completion: nil)
            
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
            // Log out
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let onbaordVC = storyboard.instantiateViewController(withIdentifier: "onboardVC") as! OnboardViewController

            self.navigationController?.setViewControllers([onbaordVC], animated: true)
            
        default:
            break
        }
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

