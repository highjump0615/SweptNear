//
//  SignupProfileViewController.swift
//  SweptUp
//
//  Created by Administrator on 6/14/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit

class SignupProfileViewController: SignupBaseViewController, UITextFieldDelegate {
    
    @IBOutlet weak var mViewPhoto: UIView!
    @IBOutlet weak var mViewFirstName: UIView!
    @IBOutlet weak var mTextFirstName: UITextField!
    @IBOutlet weak var mViewLastName: UIView!
    @IBOutlet weak var mTextLastName: UITextField!
    @IBOutlet weak var mViewBirthday: UIView!
    @IBOutlet weak var mTextBirthday: UITextField!
    @IBOutlet weak var mViewGender: UIView!
    @IBOutlet weak var mTextGender: UITextField!
    
    var mUser: User?
    
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if mUser != nil {
            self.title = "Edit Profile"
            mButNext.setTitle("Save", for: .normal)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        mViewPhoto.makeRoundBorder(width: 1.0, color: Constants.gColorGray)
        mViewFirstName.makeRoundBorder(width: 1.0, color: Constants.gColorGray)
        mViewLastName.makeRoundBorder(width: 1.0, color: Constants.gColorGray)
        mViewBirthday.makeRoundBorder(width: 1.0, color: Constants.gColorGray)
        mViewGender.makeRoundBorder(width: 1.0, color: Constants.gColorGray)
    }
    
    @IBAction func onButSignup(_ sender: Any) {
        if mUser != nil {
            self.navigationController?.popViewController(animated: true)
        }
        else {
            // go to terms & conditions page newly
            let termVC = TermsViewController(nibName: "TermsViewController", bundle: nil)
            self.navigationController?.pushViewController(termVC, animated: true)
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

}
