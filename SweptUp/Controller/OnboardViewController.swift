//
//  OnboardViewController.swift
//  SweptUp
//
//  Created by Administrator on 6/12/18.
//  Copyright © 2018 Administrator. All rights reserved.
//

import UIKit

class OnboardViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var mPageControl: UIPageControl!
    @IBOutlet weak var mScrollView: UIScrollView!
    @IBOutlet weak var mButContinue: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        mButContinue.makeRound()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func onButContinue(_ sender: Any) {
        if mPageControl.currentPage == 0 {
            // go to next view pager
            var pt = mScrollView.contentOffset
            pt.x += mScrollView.frame.size.width
            
            mScrollView.setContentOffset(pt, animated: true)
            
            // update page control
            mPageControl.currentPage = 1
        }
        else {
            // go to next page
            let signinVC = SignInViewController(nibName: "SigninViewController", bundle: nil)
            self.navigationController?.pushViewController(signinVC, animated: true)
        }
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = mScrollView.frame.size.width
        let nPage = (Int)(mScrollView.contentOffset.x / pageWidth)
        
        mPageControl.currentPage = nPage
    }
}
