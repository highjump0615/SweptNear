//
//  SignupEmailViewController.swift
//  SweptUp
//
//  Created by Administrator on 6/14/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit

class SignupEmailViewController: SignupBaseViewController, UITextFieldDelegate {

    @IBOutlet weak var mTextEmail: UITextField!
    
    @IBOutlet weak var mCheckViewValid: SignupCheckbox!
    @IBOutlet weak var mCheckViewNotUse: SignupCheckbox!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // placeholders
        mTextEmail.attributedPlaceholder = NSAttributedString(string: "Enter your email address",
                                                              attributes: [NSAttributedStringKey.foregroundColor: Constants.gColorGray])
        
        disableCheckboxes()
    }
    
    /// disable all check boxes
    override func disableCheckboxes() {
        super.disableCheckboxes()
        
        mCheckViewValid.setEnabled(enabled: false)
        mCheckViewNotUse.setEnabled(enabled: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onButNext(_ sender: Any) {
        if mButNext.isEnabled {
            // go to sign up password page
            let signupPasswordVC = SignupPasswordViewController(nibName: "SignupPasswordViewController", bundle: nil)
            signupPasswordVC.email = mTextEmail.text!
            self.navigationController?.pushViewController(signupPasswordVC, animated: true)
        }
    }
    
    @IBAction func onTextChanged(_ sender: Any) {
        // init controls
        disableCheckboxes()
        
        let email = mTextEmail.text!
        
        // check email valid and not in use
        if Utils.isEmailValid(email: email) {
            mCheckViewValid.setEnabled(enabled: true)
            
            // check if email has been used
            let database = FirebaseManager.ref()
            let query = database.child(User.TABLE_NAME)
            query.queryOrdered(byChild: User.FIELD_EMAIL)
                .queryEqual(toValue: "\(email)")
                .observeSingleEvent(of: .value, with: {snapshot in
                    if !snapshot.exists() {
                        self.mCheckViewNotUse.setEnabled(enabled: true)
                        self.mButNext.makeEnable(enable: true)
                    }
                })
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
            
            onButNext(textField)
        }
        
        return true
    }
}
