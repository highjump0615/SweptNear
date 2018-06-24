//
//  SignupProfileViewController.swift
//  SweptUp
//
//  Created by Administrator on 6/14/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import Firebase

class SignupProfileViewController: SignupBaseViewController, UITextFieldDelegate {
    
    var avatarLoaded = false
    
    static let FROM_SIGNUP = 0
    static let FROM_PROFILE = 1
    
    var type = SignupProfileViewController.FROM_SIGNUP
    
    @IBOutlet weak var mViewPhoto: UIView!
    @IBOutlet weak var mImgViewPhoto: UIImageView!
    
    @IBOutlet weak var mViewFirstName: UIView!
    @IBOutlet weak var mTextFirstName: UITextField!
    @IBOutlet weak var mViewLastName: UIView!
    @IBOutlet weak var mTextLastName: UITextField!
    @IBOutlet weak var mViewBirthday: UIView!
    @IBOutlet weak var mTextBirthday: UITextField!
    @IBOutlet weak var mViewGender: UIView!
    @IBOutlet weak var mTextGender: UITextField!
    
    var date: Date = Date() {
        didSet {
            mTextBirthday.text = date.toString(format: "yyyy/MM/dd")
        }
    }
    
    
    var genders = ["Male", "Female"]
    var genderIndex = 0 {
        didSet {
            mTextGender.text = genders[genderIndex]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // placeholders
        mTextFirstName.attributedPlaceholder = NSAttributedString(string: "First Name",
                                                              attributes: [NSAttributedStringKey.foregroundColor: Constants.gColorGray])
        mTextLastName.attributedPlaceholder = NSAttributedString(string: "Last Name",
                                                                 attributes: [NSAttributedStringKey.foregroundColor: Constants.gColorGray])
        mTextBirthday.attributedPlaceholder = NSAttributedString(string: "Date of Birth",
                                                                 attributes: [NSAttributedStringKey.foregroundColor: Constants.gColorGray])
        mTextGender.attributedPlaceholder = NSAttributedString(string: "Gender",
                                                                 attributes: [NSAttributedStringKey.foregroundColor: Constants.gColorGray])
        
        // init actions
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onUploadPhoto))
        tap.numberOfTapsRequired = 1
        mViewPhoto.isUserInteractionEnabled = true
        mViewPhoto.addGestureRecognizer(tap)
        
        // init data
        if type == SignupProfileViewController.FROM_PROFILE {
            mButNext.setTitle("Save", for: .normal)
            
            // fill info
            mImgViewPhoto.image = UIImage(named: "PhotoDefault")
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if type == SignupProfileViewController.FROM_PROFILE {
            self.title = "Edit Profile"
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        mViewPhoto.makeRoundBorder(width: 1.0, color: Constants.gColorGray)
        mViewFirstName.makeRoundBorder(width: 1.0, color: Constants.gColorGray)
        mViewLastName.makeRoundBorder(width: 1.0, color: Constants.gColorGray)
        mViewBirthday.makeRoundBorder(width: 1.0, color: Constants.gColorGray)
        mViewGender.makeRoundBorder(width: 1.0, color: Constants.gColorGray)
        
        mImgViewPhoto.makeRound()
    }
    
    /// retrieve first name with white space removed
    ///
    /// - Returns: <#return value description#>
    func getFirstName() -> String {
        let strText = mTextFirstName.text!
        return strText.trimmingCharacters(in: .whitespaces)
    }
    
    /// retrieve first name with white space removed
    ///
    /// - Returns: <#return value description#>
    func getLastName() -> String {
        let strText = mTextLastName.text!
        return strText.trimmingCharacters(in: .whitespaces)
    }
    
    @IBAction func onButSignup(_ sender: Any) {
        let _firstName = getFirstName()
        let _lastName = getLastName()
        
        if _firstName.isEmpty {
            self.alertOk(title: "First Name Invalid",
                         message: "First name cannot be empty",
                         cancelButton: "OK",
                         cancelHandler: nil)
            return
        }
        if !Utils.isNameValid(name: _firstName) {
            self.alertOk(title: "First Name Invalid",
                         message: "First name can only be normal charaters",
                         cancelButton: "OK",
                         cancelHandler: nil)
            return
        }
        
        if _lastName.isEmpty {
            self.alertOk(title: "Last Name Invalid",
                         message: "Last name cannot be empty",
                         cancelButton: "OK",
                         cancelHandler: nil)
            return
        }
        if !Utils.isNameValid(name: _lastName) {
            self.alertOk(title: "Last Name Invalid",
                         message: "Last name can only be normal charaters",
                         cancelButton: "OK",
                         cancelHandler: nil)
            return
        }
        
        if User.currentUser == nil {
            //
            // sign up new user
            //
            
            // show loading view
            showLoadingView()

            FirebaseManager.mAuth.createUser(withEmail: email!, password: password!, completion: { (user, error) in
                if let error = error {
                    // hide loading view
                    self.showLoadingView(show: false)
                    
                    self.alertOk(title: "Sign up Failed",
                                 message: error.localizedDescription,
                                 cancelButton: "OK",
                                 cancelHandler: nil)
                    return
                }
                
                // set user
                let userNew = User()
                
                // save user info
                userNew.id = (user?.uid)!
                userNew.email = self.email!
                
                User.currentUser = userNew

                self.uploadImageAndSetupUserInfo()
            })
        }
        else {
            uploadImageAndSetupUserInfo()
        }
    }
    
    func uploadImageAndSetupUserInfo() {
        // upload photo
        let user = User.currentUser!
        if avatarLoaded, let image = self.mImgViewPhoto.image {
            showLoadingView()
            
            let path = "users / " + user.id + ".png"
            
            let resized = image.resized(toWidth: 200, toHeight: 200)
            FirebaseManager.uploadImageTo(path: path, image: resized, completionHandler: { (downloadURL, error) in
                if let error = error {
                    self.showLoadingView(show: false)
                    self.alertOk(title: "Failed Uploading Photo",
                                 message: error.localizedDescription,
                                 cancelButton: "OK",
                                 cancelHandler: nil)
                    return
                }
                
                if let url = downloadURL {
                    self.setupUserInfo(imageURL: url)
                    
                } else {
                    self.setupUserInfo(imageURL: nil)
                }
            })
        }
        else {
            self.setupUserInfo(imageURL: nil)
        }
    }
    
    /// save user data into db
    ///
    /// - Parameter imageURL: <#imageURL description#>
    func setupUserInfo(imageURL: String?) {
        let user = User.currentUser
        
        // save info
        user?.firstName = getFirstName()
        user?.lastName = getLastName()
        user?.birthday = mTextBirthday.text!
        user?.gender = mTextGender.text
        
        if let url = imageURL {
            user?.photoUrl = url
        }
        
        user?.saveToDatabase()
        
        // hide loading
        showLoadingView(show: false)
        
        if type == SignupProfileViewController.FROM_PROFILE {
            // edit profile page
            self.navigationController?.popViewController(animated: true)
        }
        else {
            // signup profile page
            // go to terms & conditions page newly
            let termVC = TermsViewController(nibName: "TermsViewController", bundle: nil)
            self.navigationController?.pushViewController(termVC, animated: true)
        }

    }
    
    @objc func onUploadPhoto() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        alert.addAction(UIAlertAction(title: "Take a new photo", style: .default, handler: { (action) in
            UIViewController.takePhoto(viewController: self)
        }))
        
        alert.addAction(UIAlertAction(title: "Select from gallery", style: .default, handler: { (action) in
            UIViewController.loadFromGallery(viewController: self)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //
    // MARK: - UITextFieldDelegate
    //
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == mTextFirstName {
            mTextLastName.becomeFirstResponder()
        }
        else if textField == mTextLastName {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == mTextBirthday {
            self.view.endEditing(true)
            
            ActionSheetDatePicker.show(withTitle: "Choose birthday(optional):", datePickerMode: .date, selectedDate: date, doneBlock: { (picker, date, view) in
                if let date = date as? Date {
                    self.date = date
                }
            }, cancel: { (picker) in
                
            }, origin: self.view)
            
            return false
        }
        else if textField == mTextGender {
            self.view.endEditing(true)
            
            ActionSheetStringPicker.show(withTitle: "Choose your gender:", rows: self.genders, initialSelection: self.genderIndex, doneBlock: { (picker, index, view) in
                self.genderIndex = index
            }, cancel: { (picker) in
                
            }, origin: self.view)
            
            return false
        }
        
        return true
    }

}

extension SignupProfileViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            mImgViewPhoto.image = chosenImage
            avatarLoaded = true
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
