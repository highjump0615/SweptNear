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
import GoogleSignIn

class SigninViewController: BaseViewController, UITextFieldDelegate {
    
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
        
        // google sign in initialization
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
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
        // check connection
        if Constants.reachability.connection == .none {
            showConnectionError()
            return
        }
        
        SVProgressHUD.setContainerView(self.view)
        SVProgressHUD.show()
        
        GIDSignIn.sharedInstance().signIn()
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
            showConnectionError()
            return
        }
        
        // show loading view
        SVProgressHUD.dismiss()
        SVProgressHUD.setContainerView(self.view)
        SVProgressHUD.show()
        
        // user authentication
        FirebaseManager.mAuth.signIn(withEmail: email, password: password, completion: { (user, error) in
            
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
        FirebaseManager.mAuth.fetchProviders(forEmail: email, completion: { (providers, error) in
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
    
    /// fetch user info with basic user auth
    ///
    /// - Returns: <#return value description#>
    func fetchUserInfo(userInfo: Firebase.User? = nil,
                       firstName: String?,
                       lastName: String?,
                       photoURL: String?,
                       onFailed: @escaping(() -> ()) = {},
                       onCompleted: @escaping(() -> ()) = {}) {
        
        guard let userId = FirebaseManager.mAuth.currentUser?.uid else {
            onFailed()
            return
        }

        User.readFromDatabase(withId: userId) { (u) in
            User.currentUser = u
            
            if User.currentUser == nil {
                // get user info, from facebook account info
                if userInfo != nil {
                    let newUser = User(withId: userId)
                    
                    newUser.email = (userInfo?.email)!
                    newUser.firstName = firstName!
                    newUser.lastName = lastName!
                    newUser.photoUrl = photoURL
                    
                    User.currentUser = newUser
                }
                
                // social login, go to u type page
                let profileVC = SignupProfileViewController(nibName: "SignupProfileViewController", bundle: nil)
                profileVC.type = SignupProfileViewController.FROM_SIGNUP
                self.navigationController?.setViewControllers([profileVC], animated: true)
            }
            else {
                self.goToMain()
            }
            
            onCompleted()
        }
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

extension SigninViewController : GIDSignInDelegate, GIDSignInUIDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            SVProgressHUD.dismiss()
            
            alertOk(title: "Google Signin Failed",
                    message: error.localizedDescription,
                    cancelButton: "OK",
                    cancelHandler: nil)
            
            return
        }
        
        let email = user.profile.email
        let firstName = user.profile.givenName ?? " "
        let lastName = user.profile.familyName ?? " "
        let picture = user.profile.imageURL(withDimension: 400).absoluteString
        
        UserDefaults.standard.set(firstName, forKey: "firstName")
        UserDefaults.standard.set(lastName, forKey: "lastName")
        UserDefaults.standard.set(picture, forKey: "picture")
        
        Auth.auth().fetchProviders(forEmail: email!, completion: { (providers, error) in
            
            if error == nil {
                
                if let provider = providers?[0], provider != "google.com" {
                    let providerName = (provider == "facebook.com" ? "Facebook" : "Email")
                    SVProgressHUD.dismiss()
                    
                    self.alert(title: "Google Signin",
                               message: "Sign in with Google will replace your previous \(providerName) signin. Are you sure want to proceed?", okButton: "OK",
                               cancelButton: "Cancel",
                               okHandler: { (_) in
                        SVProgressHUD.show()
                        self.continueGoogleSignIn(user: user,
                                                  email: email!,
                                                  firstName: firstName,
                                                  lastName: lastName,
                                                  photoURL: picture)
                    }, cancelHandler: nil)
                    
                    return
                }
            }
            self.continueGoogleSignIn(user:user,
                                      email: email!,
                                      firstName: firstName,
                                      lastName: lastName,
                                      photoURL: picture)
        })
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    
    func continueGoogleSignIn(user: GIDGoogleUser,
                              email: String,
                              firstName: String,
                              lastName: String,
                              photoURL: String) {
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (user, error) in
            
            if let error = error {
                SVProgressHUD.dismiss()
                if let errorCode = AuthErrorCode(rawValue: error._code) {
                    if errorCode == AuthErrorCode.accountExistsWithDifferentCredential {
                        self.alertForOtherCredential(email: email)
                    }
                    else {
                        self.alertOk(title: "Google Signin Failed",
                                     message: error.localizedDescription,
                                     cancelButton: "OK",
                                     cancelHandler: nil)
                    }
                    
                    return
                }
            }
            
            self.fetchUserInfo(userInfo: user,
                               firstName: firstName,
                               lastName: lastName,
                               photoURL: photoURL,
                               onFailed: {
                                FirebaseManager.signOut()
            })
        }
    }
    
}
