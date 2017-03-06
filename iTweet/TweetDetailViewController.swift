//
//  TweetDetailViewController.swift
//  iTweet
//
//  Created by Brandon Sanchez on 2/28/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import UIKit
import Kingfisher
import FaveButton

class TweetDetailViewController: UIViewController, FaveButtonDelegate {
    
    @IBOutlet var outerProfileView: UIView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var screennameLabel: UILabel!
    @IBOutlet var embeddedWebPreview: UIView!
    @IBOutlet var tweetBackgroundView: UIView!
    @IBOutlet var tweetLabel: UILabel!
    @IBOutlet var likeButton: FaveButton!
    @IBOutlet var likeCountLabel: UILabel!
    @IBOutlet var retweetButton: FaveButton!
    @IBOutlet var retweetCountLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var webPreviewImageView: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var urlLabel: UILabel!
    
    var likeCount = 0
    var retweetCount = 0
    
    var tweet: Tweet! {
        didSet {
            likeCount = tweet.favoriteCount
            retweetCount = tweet.retweetCount
            //setButtonStatus()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setButtonStatus()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        
        // Button Delegates
        likeButton.delegate = self
        retweetButton.delegate = self
        
        //Default button colors
        likeButton.normalColor = UIColor.black
        retweetButton.normalColor = UIColor.black
        //likeButton.isSelected = false
        //retweetButton.isSelected = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func configureViews() {
        //self.profileImageView.kf.setImage(with: tweet.user.profileUrl)
        setProfilePic(with: tweet.user.profileUrl!)
        self.nameLabel.text = tweet.user.name
        self.screennameLabel.text = tweet.user.screenname
        self.tweetLabel.text = tweet.text
        self.timeLabel.text = tweet.timestampString
        self.retweetCountLabel.text = String(describing: tweet.retweetCount)
        self.likeCountLabel.text = String(describing: tweet.favoriteCount)
    }
    
    func setProfilePic(with imageURL: URL) {
        outerProfileView.clipsToBounds = false
        outerProfileView.layer.shadowColor = UIColor.black.cgColor
        outerProfileView.layer.shadowOpacity = 0.38
        outerProfileView.layer.shadowOffset = CGSize.zero
        outerProfileView.layer.shadowRadius = 6
        outerProfileView.layer.cornerRadius = profileImageView.frame.width / 2
        outerProfileView.layer.shadowPath = UIBezierPath(roundedRect: outerProfileView.bounds, cornerRadius: outerProfileView.frame.width / 2).cgPath
        
        self.profileImageView.kf.indicatorType = .activity
        self.profileImageView.kf.setImage(with: imageURL, options: [.transition(.fade(0.2))])
        //self.profileImageView.setImageWith(imageURL)
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
    
    // FaveButton Protocol Method
    public func faveButton(_ faveButton: FaveButton, didSelected selected: Bool) {
        
    }
    
    // Configure Button status
    // TODO: - need to get the correct label
    func setButtonStatus() {
        //initiate Keys and defaults
        let retweetKey = String(describing: tweet.id) + "retweet"
        let likeKey = String(describing: tweet.id) + "like"
        let defaults = UserDefaults.standard
        
        // Check retweet status
        if defaults.value(forKey: retweetKey) as? Bool == false || defaults.value(forKey: retweetKey) == nil {
            retweetButton.isSelected = false
        } else {
            retweetButton.isSelected = true
        }
        
        // Check like status
        if defaults.value(forKey: likeKey) as? Bool == false || defaults.value(forKey: likeKey) == nil {
            likeButton.isSelected = false
        } else {
            likeButton.isSelected = true
        }
    }

    // MARK: - Tweet Actions
    //TODO: implement this in a protocol
    @IBAction func onLike(_ sender: Any) {
        
        let likeKey = String(describing: tweet.id) + "like"
        let defaults = UserDefaults.standard
        if defaults.value(forKey: likeKey) as? Bool == false || defaults.value(forKey: likeKey) == nil {
            defaults.set(true, forKey: likeKey)
            TwitterClient.likeTweet(withID: self.tweet.id)
            likeCount += 1
            self.likeCountLabel.text = String(describing: tweet.favoriteCount)
            //removeActionView(withDelay: 0.5)
        } else {
            //TODO:- Unlike
            TwitterClient.unlikeTweet(withID: self.tweet.id)
            defaults.set(false, forKey: likeKey)
            likeCount -= 1
            self.likeCountLabel.text = String(describing: tweet.favoriteCount)
            likeButton.isSelected = false
            //removeActionView(withDelay: 0.5)
        }

    }
    
    @IBAction func onRetweet(_ sender: Any) {
        
        let tweetKey = String(describing: tweet.id) + "retweet"
        let defaults = UserDefaults.standard
        if defaults.value(forKey: tweetKey) as? Bool == false || defaults.value(forKey: tweetKey) == nil {
            defaults.set(true, forKey: tweetKey)
            TwitterClient.retweetTweet(withID: self.tweet.id)
            retweetCount += 1
            self.retweetCountLabel.text = String(describing: tweet.retweetCount)
        } else {
            //TODO:- Unretweet
            TwitterClient.unretweetTweet(withID: self.tweet.id)
            defaults.set(false, forKey: tweetKey)
            retweetCount -= 1
            self.retweetCountLabel.text = String(describing: tweet.retweetCount)
            retweetButton.isSelected = false
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
