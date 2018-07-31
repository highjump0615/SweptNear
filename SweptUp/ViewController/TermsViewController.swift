//
//  TermsViewController.swift
//  SweptUp
//
//  Created by Administrator on 6/14/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit
import WebKit

class TermsViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var mWebView: WKWebView!
    @IBOutlet weak var mIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mBottomBar: UINavigationBar!
    @IBOutlet weak var mConstraintBottom: NSLayoutConstraint!
    
    static let TERMS_FROM_SIGNUP = 0
    static let TERMS_FROM_SETTING = 1
    static let PRIVACY_POLICY = 2
    
    var type = TermsViewController.TERMS_FROM_SIGNUP
    var mUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mWebView.navigationDelegate = self
        
        let url = type == TermsViewController.PRIVACY_POLICY ?
            URL(string: Config.urlPrivacyPolicy)! : URL(string: Config.urlTermCondition)!
        mWebView.load(URLRequest(url: url))
        mIndicator.startAnimating()
        
        if type != TermsViewController.TERMS_FROM_SIGNUP {
            hideBottombar()
        }
    }
    
    private func hideBottombar() {
        mBottomBar.removeFromSuperview()
        mConstraintBottom.constant = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // title
        self.title = type == TermsViewController.PRIVACY_POLICY ? "Privacy Policy" : "Terms and Conditions"
    }
    
    @IBAction func onButAccept(_ sender: Any) {
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
    
    // MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // hide loading indicator
        mIndicator.isHidden = true
    }

}
