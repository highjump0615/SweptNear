//
//  BaseViewController.swift
//  SweptUp
//
//  Created by Administrator on 6/17/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // clear title
        self.title = " "
    }
    
    /// go to main page according to user type
    func goToMain() {
        // go to home page with new navigation
        let homeVC = HomeViewController(nibName: "HomeViewController", bundle: nil)        
        self.navigationController?.setViewControllers([homeVC], animated: true)
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
