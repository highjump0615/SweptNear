//
//  ForgetViewController.swift
//  SweptUp
//
//  Created by Administrator on 6/14/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit

class ForgetViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var mViewEmail: UIView!
    @IBOutlet weak var mTextEmail: UITextField!
    @IBOutlet weak var mButSubmit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showNavbar()
        
        // title
        self.title = "Reset Password"
        
        // placeholders
        mTextEmail.attributedPlaceholder = NSAttributedString(string: "Email Address",
                                                              attributes: [NSAttributedStringKey.foregroundColor: Constants.gColorGray])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        mViewEmail.makeRoundBorder(width: 1.0, color: Constants.gColorGray)
        mButSubmit.makeRound()
    }
    
    @IBAction func onButSubmit(_ sender: Any) {
        if Constants.reachability.connection == .none {
            showConnectionError()
            return
        }
        
        let email = mTextEmail.text!
        let trimmed = email.trimmingCharacters(in: CharacterSet.whitespaces)
        
        if trimmed == "" {
            alertOk(title: "Email Invalid",
                    message: "Please enter email address",
                    cancelButton: "OK",
                    cancelHandler: nil)
            return
        }
        
        if !Utils.isEmailValid(email: email) {
            alertOk(title: "Email Invalid",
                    message: "Please enter valid email address",
                    cancelButton: "OK",
                    cancelHandler: nil)
            return
        }
        
        FirebaseManager.mAuth.sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                if error.localizedDescription.contains("no user record") {
                    self.alertOk(title: "Account not found",
                               message: "Email entered is not registered. Please check your email address",
                               cancelButton: "OK",
                               cancelHandler: nil)
                }
                else {
                    self.alertOk(title: "Submit Failed",
                                 message: error.localizedDescription,
                                 cancelButton: "OK",
                                 cancelHandler: nil)
                }
            } else {
                self.alertOk(title: "Submitted Successfully",
                             message: "Success! We’ve sent a password reset link to your email",
                             cancelButton: "OK",
                             cancelHandler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                })
            }
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

    // MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == mTextEmail {
            textField.resignFirstResponder()
        }
        
        return true
    }
}
