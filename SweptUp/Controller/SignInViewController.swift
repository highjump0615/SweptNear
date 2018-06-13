//
//  SignInViewController.swift
//  SweptUp
//
//  Created by Administrator on 6/13/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding

class SignInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var mViewInput: UIView!
    @IBOutlet weak var mViewEmail: UIView!
    @IBOutlet weak var mTextEmail: UITextField!
    @IBOutlet weak var mViewPassword: UIView!
    @IBOutlet weak var mTextPassword: UITextField!
    @IBOutlet weak var mButSignin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // placeholders
        let colorGray = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.13)
        mTextEmail.attributedPlaceholder = NSAttributedString(string: "Email Address",
                                                              attributes: [NSAttributedStringKey.foregroundColor: colorGray])
        mTextPassword.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                 attributes: [NSAttributedStringKey.foregroundColor: colorGray])
        // keyboard avoiding
        KeyboardAvoiding.avoidingView = mViewInput
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        mViewEmail.makeRoundBorder()
        mViewPassword.makeRoundBorder()
        mButSignin.makeRound()
    }
    
    
    @IBAction func onButSignin(_ sender: Any) {
        doSignin()
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
            mTextPassword.becomeFirstResponder()
        }
        else if textField == mTextPassword {
            textField.resignFirstResponder()
            doSignin()
        }
        
        return true
    }
    
    private func doSignin() {
        
    }

}
