//
//  SignupPasswordViewController.swift
//  SweptUp
//
//  Created by Administrator on 6/14/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit

class SignupPasswordViewController: SignupBaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var mTextPassword: UITextField!
    
    @IBOutlet weak var mCheckbox6: SignupCheckbox!
    @IBOutlet weak var mCheckboxUppercase: SignupCheckbox!
    @IBOutlet weak var mCheckboxLowercase: SignupCheckbox!
    @IBOutlet weak var mCheckboxNumber: SignupCheckbox!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // placeholders
        mTextPassword.attributedPlaceholder = NSAttributedString(string: "Enter your password",
                                                              attributes: [NSAttributedStringKey.foregroundColor: Constants.gColorGray])
        
        disableCheckboxes()
    }
    
    override func disableCheckboxes() {
        super.disableCheckboxes()
        
        mCheckbox6.setEnabled(enabled: false)
        mCheckboxUppercase.setEnabled(enabled: false)
        mCheckboxLowercase.setEnabled(enabled: false)
        mCheckboxNumber.setEnabled(enabled: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onButNext(_ sender: Any) {
        if mButNext.isEnabled {
            // go to confirm password page
            let signupPasswordVC = SignupCPasswordViewController(nibName: "SignupCPasswordViewController", bundle: nil)
            signupPasswordVC.email = email
            signupPasswordVC.password = mTextPassword.text!
            self.navigationController?.pushViewController(signupPasswordVC, animated: true)
        }
    }
    
    @IBAction func onTextChanged(_ sender: Any) {
        // init controls
        disableCheckboxes()
        
        let passwd = mTextPassword.text!
        
        // check input validity
        var nCondition = 0
        if passwd.count >= 6 {
            mCheckbox6.setEnabled(enabled: true)
            nCondition += 1
        }
        if passwd.containsUppercase {
            mCheckboxUppercase.setEnabled(enabled: true)
            nCondition += 1
        }
        if passwd.containsLowercase {
            mCheckboxLowercase.setEnabled(enabled: true)
            nCondition += 1
        }
        if passwd.containsNumber {
            mCheckboxNumber.setEnabled(enabled: true)
            nCondition += 1
        }
        
        if nCondition >= 4 {
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
            
            onButNext(textField)
        }
        
        return true
    }

}
