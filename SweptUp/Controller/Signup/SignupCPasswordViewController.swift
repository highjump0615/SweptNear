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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // placeholders
        mTextPassword.attributedPlaceholder = NSAttributedString(string: "Re-enter your password",
                                                              attributes: [NSAttributedStringKey.foregroundColor: gColorGray])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onButNext(_ sender: Any) {
        // go to signup profile page
        let signupProfileVC = SignupProfileViewController(nibName: "SignupProfileViewController", bundle: nil)
        self.navigationController?.pushViewController(signupProfileVC, animated: true)
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
