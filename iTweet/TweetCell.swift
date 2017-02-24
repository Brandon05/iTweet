//
//  TweetCell.swift
//  iTweet
//
//  Created by Brandon Sanchez on 2/23/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import UIKit
import AFNetworking
import URLEmbeddedView

class TweetCell: UICollectionViewCell {

    @IBOutlet var outerView: UIView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var screennameLabel: UILabel!
    @IBOutlet var tweetLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet weak var embeddedView: URLEmbeddedView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //embeddedWebView.delegate = self
    }
    
    func bind(_ tweet: Tweet) -> Self {
        setProfilePic(with: tweet.user.profileUrl!)
        nameLabel.text = tweet.user.name
        screennameLabel.text = "@\(tweet.user.screenname!)"
        tweetLabel.text = tweet.text
        timeLabel.text = String(describing: tweet.timestamp)
        if tweet.displayURL != nil {
            embeddedView.loadURL(tweet.displayURL!)
        //embeddedWebView.loadRequest(URLRequest(url: tweet.displayURL!))
        }
        
        return self
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

}
