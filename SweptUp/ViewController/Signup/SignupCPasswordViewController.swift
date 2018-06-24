//
//  SignupPasswordViewController.swift
//  SweptUp
//
//  Created by Administrator on 6/14/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit

class SignupCPasswordViewController: SignupBaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var mTextPassword: UITextField!
    @IBOutlet weak var mCheckboxMatch: SignupCheckbox!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // placeholders
        mTextPassword.attributedPlaceholder = NSAttributedString(string: "Re-enter your password",
                                                              attributes: [NSAttributedStringKey.foregroundColor: Constants.gColorGray])
        
        disableCheckboxes()
    }
    
    override func disableCheckboxes() {
        super.disableCheckboxes()
        
        mCheckboxMatch.setEnabled(enabled: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onButNext(_ sender: Any) {
        if mButNext.isEnabled {
            // go to signup profile page
            let signupProfileVC = SignupProfileViewController(nibName: "SignupProfileViewController", bundle: nil)
            signupProfileVC.email = email
            signupProfileVC.password = password
            self.navigationController?.pushViewController(signupProfileVC, animated: true)
        }
    }

    @IBAction func onTextChanged(_ sender: Any) {
        // init controls
        disableCheckboxes()
        
        let passwdConfirm = mTextPassword.text!
        if self.password == passwdConfirm {
            mCheckboxMatch.setEnabled(enabled: true)
            mButNext.makeEnable(enable: true)
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
        if textField == mTextPassword {
            textField.resignFirstResponder()
        }
        
        return true
    }

}
