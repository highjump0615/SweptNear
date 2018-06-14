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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // placeholders
        mTextPassword.attributedPlaceholder = NSAttributedString(string: "Enter your password",
                                                              attributes: [NSAttributedStringKey.foregroundColor: gColorGray])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onButNext(_ sender: Any) {
        // go to confirm password page
        let signupPasswordVC = SignupCPasswordViewController(nibName: "SignupCPasswordViewController", bundle: nil)
        self.navigationController?.pushViewController(signupPasswordVC, animated: true)
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
