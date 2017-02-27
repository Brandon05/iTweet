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

class TweetCell: UICollectionViewCell, UIGestureRecognizerDelegate {

    @IBOutlet var tweetBackgroundView: TweetBackgroundView!
    @IBOutlet var outerView: UIView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var screennameLabel: UILabel!
    @IBOutlet var tweetLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet weak var embeddedView: UIView!
    @IBOutlet var urlLabel: UILabel!
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var urlImageView: UIImageView!
    @IBOutlet var actionView: blurTweetView!
    let tap = UITapGestureRecognizer()
    let linkPreview = SwiftLinkPreview()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //embeddedWebView.delegate = self
        self.tweetLabel.preferredMaxLayoutWidth = 200
        
        
        tap.delegate = self
        tap.addTarget(self, action: #selector(self.onTap(_:)))
        self.sendSubview(toBack: actionView)
        actionView.alpha = 0
        //actionView.backgroundColor = nil
        
    }
    
    func bind(_ tweet: Tweet) -> Self {
        setProfilePic(with: tweet.user.profileUrl!)
        nameLabel.text = tweet.user.name
        screennameLabel.text = "@\(tweet.user.screenname!)"
        tweetLabel.text = tweet.text
        timeLabel.text = String(describing: tweet.timestamp)
        if tweet.displayURL != nil && tweet.displayURL != "" {
            print(tweet.displayURL)
//            linkPreview.preview(tweet.displayURL,
//            onSuccess: { (result: [String : AnyObject]) in
//                let images = result["images"] as? [String]
//                print("IMAGES: - \((URL(string: images![0])!))")
//                let imageURL = URL(string: images![0])!
//                self.urlImageView.setImageWith(imageURL)
//                self.textLabel.text = result["description"] as? String
//                self.urlLabel.text = result["url"] as? String
//            }, onError: { (error) in
//                print(error)
//            })
            
            //embeddedView.loadURL(tweet.displayURL!)
        //embeddedWebView.loadRequest(URLRequest(url: tweet.displayURL!))
        }
        
        actionView.isUserInteractionEnabled = true
        actionView.addGestureRecognizer(tap)
        //actionView.alpha = 0
        
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.frame = CGRect(x: 0, y: self.frame.origin.y, width: self.superview!.frame.size.width, height: self.frame.size.height)
    }
    
    func onTap(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3) {
            self.actionView.alpha = 0
        }
        self.sendSubview(toBack: actionView)
    }

    @IBAction func onTapp(_ sender: Any) {
        self.bringSubview(toFront: actionView)
        UIView.animate(withDuration: 0.3) { 
            self.actionView.alpha = 1
        }
    }

}
