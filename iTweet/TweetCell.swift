//
//  TweetCell.swift
//  iTweet
//
//  Created by Brandon Sanchez on 2/23/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import UIKit
import AFNetworking
import SwiftLinkPreview
import FaveButton

class TweetCell: UITableViewCell, FaveButtonDelegate {
    


    @IBOutlet var tweetBackgroundView: TweetBackgroundView!
    @IBOutlet var outerView: UIView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var screennameLabel: UILabel!
    @IBOutlet var tweetLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet weak var embeddedView: UIView!
    @IBOutlet var urlLabel: UILabel!
    @IBOutlet var urlDescriptionLabel: UILabel!
    @IBOutlet var urlImageView: UIImageView!
    @IBOutlet var actionView: TweetBackgroundView!
    @IBOutlet var likeButton: FaveButton!
    @IBOutlet var retweetButton: FaveButton!
    @IBOutlet var likeCountLabel: UILabel!
    @IBOutlet var retweetCountLabel: UILabel!
    
    var tweetID = Int()
    var retweetCount = Int()
    var likeCount = Int()
    
    let tap = UITapGestureRecognizer()
    let linkPreview = SwiftLinkPreview()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.tweetLabel.preferredMaxLayoutWidth = 200
        
        // Tap Gesture recognizer for actionView
        tap.delegate = self
        tap.addTarget(self, action: #selector(self.onTap(_:)))
        
        // Initially sends actioView to the back, only way actionView works for now
        self.sendSubview(toBack: actionView)
        actionView.alpha = 0
        
        // Button Delegates
        likeButton.delegate = self
        retweetButton.delegate = self
        
        //Default button colors
        likeButton.normalColor = UIColor.black
        retweetButton.normalColor = UIColor.black
        likeButton.isSelected = false
        retweetButton.isSelected = false
    }
    
    func bind(_ tweet: Tweet) -> Self {
        
        //Configure:- TweetView Data
        setProfilePic(with: tweet.user.profileUrl!)
        nameLabel.text = tweet.user.name
        nameLabel.labelShadows()
        screennameLabel.text = "@\(tweet.user.screenname!)"
        screennameLabel.labelShadows()
        tweetLabel.text = tweet.text
        timeLabel.text = tweet.timestampString
        
        // if there is a url, set up Swift Preview
        if tweet.displayURL != nil && tweet.displayURL != "" {
           //setSwiftPreview(withTweet: tweet)
        }
        
        // Configure:- ActionView
        actionView.isUserInteractionEnabled = true
        actionView.addGestureRecognizer(tap)
        
        // Configure:- Action Button Variables
        self.tweetID = tweet.id
        self.retweetCountLabel.text = String(describing: tweet.retweetCount)
        self.retweetCount = tweet.retweetCount
        self.likeCountLabel.text = String(describing: tweet.favoriteCount)
        self.likeCount = tweet.favoriteCount
        
        // Set Action Button color
        setDefaultButtonColor()
        
        return self
    }
    
    // Sets up the data for Swift Preview class
    func setSwiftPreview(withTweet tweet: Tweet) {
        linkPreview.preview(tweet.displayURL, onSuccess: { (result: [String : AnyObject]) in
            let images = result["images"] as? [String]
            //print("IMAGES: - \((URL(string: images![0])!))")
            let imageURL = URL(string: images![0])!
            self.urlImageView.setImageWith(imageURL)
            self.urlDescriptionLabel.text = result["description"] as? String
            self.urlLabel.text = result["url"] as? String
        }, onError: { (error) in
            print(error)
        })

    }
    
    func setDefaultButtonColor() {
        if UserDefaults.standard.value(forKey: String(describing: tweetID) + "retweet") as? Bool == true {
            //retweetButton.normalColor = UIColor.green
            retweetButton.isSelected = true
        }
        if UserDefaults.standard.value(forKey: String(describing: tweetID) + "like") as? Bool == true {
            //likeButton.normalColor = UIColor.red
            likeButton.isSelected = true
        }
    }
    
    func setProfilePic(with imageURL: URL) {
        outerView.clipsToBounds = false
        outerView.layer.shadowColor = UIColor.black.cgColor
        outerView.layer.shadowOpacity = 0.38
        outerView.layer.shadowOffset = CGSize.zero
        outerView.layer.shadowRadius = 6
        outerView.layer.cornerRadius = profileImageView.frame.width / 2
        outerView.layer.shadowPath = UIBezierPath(roundedRect: outerView.bounds, cornerRadius: profileImageView.frame.width / 2).cgPath
        
        self.profileImageView.setImageWith(imageURL)
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.borderWidth = 3
        profileImageView.layer.borderColor = UIColor.darkGray.cgColor
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.layer.shadowPath = UIBezierPath(rect: profileImageView.bounds).cgPath
        profileImageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        profileImageView.layer.shadowRadius = 6
        profileImageView.layer.shadowColor = UIColor.black.cgColor
        profileImageView.layer.shadowOpacity = 0.38
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //self.frame = CGRect(x: 0, y: self.frame.origin.y, width: self.superview!.frame.size.width, height: self.frame.size.height)
    }
    
    func removeActionView(withDelay delay: Double) {
        UIView.animate(withDuration: 0.3, delay: delay, options: [], animations: {
            self.actionView.alpha = 0
        }) { (finished: Bool) in
            self.sendSubview(toBack: self.actionView)
        }
    }
    
    func addActionView() {
        self.bringSubview(toFront: actionView)
        UIView.animate(withDuration: 0.3) {
            self.actionView.alpha = 1
        }
    }
    
    // Target for actionView UITapGestureRecognizer
    func onTap(_ sender: UITapGestureRecognizer) {
        removeActionView(withDelay: 0)
    }
    
    // IBAction to present actionView
    @IBAction func onTapp(_ sender: Any) {
        self.bringSubview(toFront: actionView)
        UIView.animate(withDuration: 0.3) { 
            self.actionView.alpha = 1
        }
    }
    
    // FaveButton Protocol Method
    public func faveButton(_ faveButton: FaveButton, didSelected selected: Bool) {
        
    }
    
    @IBAction func onLike(_ sender: Any) {
        let likeKey = String(describing: tweetID) + "like"
        let defaults = UserDefaults.standard
        print(defaults.value(forKey: likeKey) as? Bool)
        if defaults.value(forKey: likeKey) as? Bool == false || defaults.value(forKey: likeKey) == nil {
            defaults.set(true, forKey: likeKey)
            TwitterClient.likeTweet(withID: self.tweetID)
            likeCount += 1
            self.likeCountLabel.text = String(describing: likeCount)
            removeActionView(withDelay: 0.5)
        } else {
            //TODO:- Unlike
            TwitterClient.unlikeTweet(withID: self.tweetID)
            defaults.set(false, forKey: likeKey)
            likeCount -= 1
            self.likeCountLabel.text = String(describing: likeCount)
            likeButton.isSelected = false
            removeActionView(withDelay: 0.5)
        }
        
    }
    
    @IBAction func onRetweet(_ sender: Any) {
        let tweetKey = String(describing: tweetID) + "retweet"
        let defaults = UserDefaults.standard
        print(defaults.value(forKey: tweetKey) as? Bool)
        if defaults.value(forKey: tweetKey) as? Bool == false || defaults.value(forKey: tweetKey) == nil {
            defaults.set(true, forKey: tweetKey)
            TwitterClient.retweetTweet(withID: self.tweetID)
            retweetCount += 1
            self.retweetCountLabel.text = String(describing: retweetCount)
            removeActionView(withDelay: 0.5)
        } else {
            //TODO:- Unretweet
            TwitterClient.unretweetTweet(withID: self.tweetID)
            defaults.set(false, forKey: tweetKey)
            retweetCount -= 1
            self.retweetCountLabel.text = String(describing: retweetCount)
            retweetButton.isSelected = false
            removeActionView(withDelay: 0.5)
        }
        
    }
    
    
}

//extension UILabel {
//    func labelShadows() {
//        //self.layer.shadowOffset = CGSize(width: 0, height: 0)
//        self.layer.shadowOpacity = 0.38
//        self.layer.shadowRadius = 4
//        self.layer.shadowColor = UIColor.black.withAlphaComponent(0.28).cgColor
//        self.layer.shadowOffset = CGSize(width: 0, height: 0)
//    }
//}
