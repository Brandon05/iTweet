//
//  TweetComposeViewController.swift
//  TwitterDemo
//
//  Created by Brandon Sanchez on 2/13/16.
//  Copyright © 2016 Brandon Sanchez. All rights reserved.
//

import UIKit

class TweetComposeViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet var profileImage: UIImageView!
    //@IBOutlet var tweetTextField: UITextField!
        
    @IBOutlet var tweetTextView: UITextView!
    @IBOutlet var dissmissTweetButton: UIButton!
    var userTweet: Tweet?
    
    
    var customView: UIView = UIView()
    var characterCountLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 40, height: 21))
    
    static let characterCount = 140
   

    override func viewDidLoad() {
        super.viewDidLoad()
        let imageUrl = User.currentUser?.profileUrl
        profileImage.setImageWith(imageUrl! as URL)
        
        tweetTextView.delegate = self
        
        tweetTextView.text = "What's Happening?"
        tweetTextView.textColor = UIColor.lightGray
        
        tweetTextView.becomeFirstResponder()
        
        self.customView.frame = CGRect(x: 0,y: 0,width: 40,height: 21)

        //print(characterCountLabel.text!)
        
        self.customView.addSubview(characterCountLabel)
        
        let characterLimit = 140 - (tweetTextView.text!.characters.count)
        self.characterCountLabel.text = "\(characterLimit)"
        characterCountLabel.textColor = UIColor.lightGray
        
        let numberToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        numberToolbar.barStyle = UIBarStyle.default
        
        numberToolbar.items = [
            UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(TweetComposeViewController.keyboardCancelButtonTapped)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Tweet", style: UIBarButtonItemStyle.plain, target: self, action: #selector(TweetComposeViewController.keyboardTweetButtonTapped)),
            UIBarButtonItem(customView: self.customView)
            ]
        
        numberToolbar.sizeToFit()
        tweetTextView.inputAccessoryView = numberToolbar
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dissmissTweet(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func keyboardCancelButtonTapped() {
        tweetTextView.resignFirstResponder()
    }
    
    func keyboardTweetButtonTapped() {
        self.dismiss(animated: true, completion: nil)
        // Create Tweet and pass it via segue
        //performSegue(withIdentifier: "tweetPressed", sender: tweetTextView)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        tweetTextView.text = ""
        tweetTextView.textColor = UIColor.black
    }
    
    func textViewDidChange(_ textView: UITextView) {
        //tweetTextView.sizeToFit()
                let characterLimit = 140 - (tweetTextView.text!.characters.count)
                self.characterCountLabel.text = "\(characterLimit)"
        
                if characterLimit < 0 {
                characterCountLabel.text = "0"
                tweetTextView.text = String(tweetTextView.text!.characters.dropLast())
                characterCountLabel.textColor = UIColor.red
                } else if characterLimit == 0 {
                characterCountLabel.textColor = UIColor.red
                    
                } else {
                characterCountLabel.textColor = UIColor.lightGray
                }

    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "tweetPressed" {
//            let destination = segue.destination as! HomeTimelineViewController
//            destination.userDidTweet = true
//            //destination.userTweet = Tweet(dictionary: NSDictionary)
//        }
//    }
 

}
