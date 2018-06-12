//
//  SignInViewController.swift
//  SweptUp
//
//  Created by Administrator on 6/13/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
