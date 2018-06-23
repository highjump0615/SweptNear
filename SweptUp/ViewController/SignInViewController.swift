//
//  SignInViewController.swift
//  SweptUp
//
//  Created by Administrator on 6/13/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding
import SVProgressHUD
import Firebase

class SignInViewController: BaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var mViewInput: UIView!
    @IBOutlet weak var mViewEmail: UIView!
    @IBOutlet weak var mTextEmail: UITextField!
    @IBOutlet weak var mViewPassword: UIView!
    @IBOutlet weak var mTextPassword: UITextField!
    @IBOutlet weak var mButSignin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = " "

        // placeholders
        let colorGray = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.13)
        mTextEmail.attributedPlaceholder = NSAttributedString(string: "Email Address",
                                                              attributes: [NSAttributedStringKey.foregroundColor: colorGray])
        mTextPassword.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                 attributes: [NSAttributedStringKey.foregroundColor: colorGray])
        // keyboard avoiding
        KeyboardAvoiding.avoidingView = mViewInput
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
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
    
    @IBAction func onButForget(_ sender: Any) {
        // go to forget password page
        let forgetVC = ForgetViewController(nibName: "ForgetViewController", bundle: nil)
        self.navigationController?.pushViewController(forgetVC, animated: true)
    }
    
    @IBAction func onButSignup(_ sender: Any) {
        // go to sign up page
        let signupVC = SignupEmailViewController(nibName: "SignupEmailViewController", bundle: nil)
        self.navigationController?.pushViewController(signupVC, animated: true)
    }
    
    @IBAction func onButFacebook(_ sender: Any) {
    }
    
    @IBAction func onButGoogle(_ sender: Any) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    /// sign in
    private func doSignin() {
        var email = mTextEmail.text!
        var password = mTextPassword.text!
        
        self.view.endEditing(true)
        
        // trim white spaces
        email = email.trimmingCharacters(in: CharacterSet.whitespaces)
        password = password.trimmingCharacters(in: CharacterSet.whitespaces)
        
        //
        // check input validity
        //
        if email == "" {
            alertOk(title: "Email Invalid", message: "Please enter your email", cancelButton: "OK", cancelHandler: nil)
            return
        }
        if password == "" {
            alertOk(title: "Password Invalid", message: "Please enter your password", cancelButton: "OK", cancelHandler: nil)
            return
        }
        if !email.contains("@") || !Utils.isEmailValid(email: email){
            alertOk(title: "Email Invalid", message: "Please enter valid email address", cancelButton: "OK", cancelHandler: nil)
            return
        }
        
        // check connection
        if Constants.reachability.connection == .none {
            alertOk(title: "No internet connection", message: "Please connect to the internet and try again", cancelButton: "OK", cancelHandler: nil)
            return
        }
        
        // show loading view
        SVProgressHUD.dismiss()
        SVProgressHUD.setContainerView(self.view)
        SVProgressHUD.show()
        
        // user authentication
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if let error = error {
                SVProgressHUD.dismiss()
                
                if let errorCode = AuthErrorCode(rawValue: error._code) {
                    if errorCode == AuthErrorCode.accountExistsWithDifferentCredential {
                        self.alertForOtherCredential(email: email)
                    }
                    else {
                        self.alertOk(title: "Login Failed",
                                     message: error.localizedDescription,
                                     cancelButton: "OK",
                                     cancelHandler: nil)
                    }
                }
            }
            else {
                // go to home page
                self.goToMain()
            }
        })
    }
    
    func alertForOtherCredential(email: String) {
        Auth.auth().fetchProviders(forEmail: email, completion: { (providers, error) in
            if error == nil {
                if providers?[0] == "google.com" {
                    DispatchQueue.main.async {
                        self.alertOk(title: "Login", message: "You already signed in with Google. Please sign in with Google.", cancelButton: "OK", cancelHandler: nil)
                    }
                } else if providers?[0] == "facebook.com" {
                    DispatchQueue.main.async {
                        self.alertOk(title: "Login", message: "You already signed in with Facebook. Please sign in with Facebook.", cancelButton: "OK", cancelHandler: nil)
                    }
                }else {
                    DispatchQueue.main.async {
                        self.alertOk(title: "Login", message: "You already signed in with email. Please use email to log in.", cancelButton: "OK", cancelHandler: nil)
                    }
                }
            } else {
                
            }
        })
    }
    
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


}
