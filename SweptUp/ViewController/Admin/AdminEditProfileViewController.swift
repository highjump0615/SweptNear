//
//  AdminEditProfileViewController.swift
//  SweptUp
//
//  Created by Administrator on 7/29/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit
import Firebase

class AdminEditProfileViewController: BaseViewController {
    
    @IBOutlet weak var mViewEmail: UIView!
    @IBOutlet weak var mTextEmail: UITextField!
    @IBOutlet weak var mViewOldPwd: UIView!
    @IBOutlet weak var mTextOldPwd: UITextField!
    @IBOutlet weak var mViewPwd: UIView!
    @IBOutlet weak var mTextPwd: UITextField!
    @IBOutlet weak var mViewConfirmPwd: UIView!
    @IBOutlet weak var mTextConfirmPwd: UITextField!
    
    @IBOutlet weak var mButSave: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Edit Profile"

        // init data
        let userCurrent = User.currentUser!
        
        mTextEmail.text = userCurrent.email
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        mViewEmail.makeRoundBorder(width: 1.0, color: Constants.gColorGray)
        mViewOldPwd.makeRoundBorder(width: 1.0, color: Constants.gColorGray)
        mViewPwd.makeRoundBorder(width: 1.0, color: Constants.gColorGray)
        mViewConfirmPwd.makeRoundBorder(width: 1.0, color: Constants.gColorGray)
        
        mButSave.makeRound()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func onButSave(_ sender: Any) {
        let old = mTextOldPwd.text!
        let passwd = mTextPwd.text!
        let confirmPasswd = mTextConfirmPwd.text!
        
        // no password change
        if passwd.isEmpty {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        // old password
        if old.isEmpty {
            self.alertOk(title: "Old Password Empty",
                         message: "Old password is needed to change your password",
                         cancelButton: "OK",
                         cancelHandler: nil)
            
            return
        }
        
        // password does not confirm
        if passwd != confirmPasswd {
            self.alertOk(title: "Password Mismatch",
                         message: "Confirm password is not matching to password",
                         cancelButton: "OK",
                         cancelHandler: nil)
            
            return
        }
        
        // show loading view
        showLoadingView()
        
        let userCurrent = User.currentUser!
        
        let credential = EmailAuthProvider.credential(withEmail: userCurrent.email, password: old)
        Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (error) in
            if let error = error {
                // hide loading view
                self.showLoadingView(show: false)
                
                self.alertOk(title: "Old password is not correct",
                             message: error.localizedDescription,
                             cancelButton: "OK",
                             cancelHandler: nil)
                return
            }
            
            Auth.auth().currentUser?.updatePassword(to: passwd, completion: { (error) in
                if let error = error {
                    // hide loading view
                    self.showLoadingView(show: false)
                    
                    self.alertOk(title: "Failed changing password",
                                 message: error.localizedDescription,
                                 cancelButton: "OK",
                                 cancelHandler: nil)
                    return
                }
            
                self.navigationController?.popViewController(animated: true)                
            })
        })
    }
    
}

extension AdminEditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == mTextOldPwd {
            mTextPwd.becomeFirstResponder()
        }
        else if textField == mTextPwd {
            mTextConfirmPwd.becomeFirstResponder()
        }
        else if textField == mTextConfirmPwd {
            textField.resignFirstResponder()
        }
        
        return true
    }
}
