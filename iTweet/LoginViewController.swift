//
//  LoginViewController.swift
//  iTweet
//
//  Created by Brandon Sanchez on 2/13/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    @IBOutlet var topConstraint: NSLayoutConstraint!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var twitterImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//        let topConstraint = NSLayoutConstraint(item: self.twitterImageView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 50)
//        view.addConstraint(topConstraint)
//        twitterImageView.addConstraint(topConstraint)
        self.topConstraint.constant = 50
        
        //twitterImageView.setNeedsLayout()
        UIView.animate(withDuration: 1.6, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }) { (finished: Bool) in
            UIView.animate(withDuration: 0.4, animations: { 
                self.loginButton.alpha = 1
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onLogin(_ sender: Any) {
        print(TwitterClient.sharedInstance?.isAuthorized)
        TwitterClient.login { (result) in
            switch result {
            case .success:
                TwitterClient.loginGroup.notify(queue: .main, execute: { 
                    print("SUCCESS")
                    self.performSegue(withIdentifier: "loginSegue", sender: nil)
                })
            case .failure(let error):
                print(error)
            }
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
