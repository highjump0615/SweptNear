//
//  SignupBaseViewController.swift
//  SweptUp
//
//  Created by Administrator on 6/14/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit

class SignupBaseViewController: UIViewController {
    
    @IBOutlet weak var mViewInput: UIView!
    @IBOutlet weak var mButNext: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        showNavbar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        mViewInput.makeRoundBorder(width: 1.0, color: gColorGray)
        mButNext.makeRound()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // title
        self.title = "Sign Up"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // clear title
        self.title = " "
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
