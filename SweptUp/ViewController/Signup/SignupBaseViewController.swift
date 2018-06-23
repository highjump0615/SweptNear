//
//  SignupBaseViewController.swift
//  SweptUp
//
//  Created by Administrator on 6/14/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit

class SignupBaseViewController: BaseViewController {
    
    @IBOutlet weak var mViewInput: UIView?
    @IBOutlet weak var mButNext: UIButton!
    
    var email: String?
    var password: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        showNavbar()
        
        mButNext.makeEnable(enable: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        mViewInput?.makeRoundBorder(width: 1.0, color: Constants.gColorGray)
        mButNext.makeRound()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // title
        self.title = "Sign Up"
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
