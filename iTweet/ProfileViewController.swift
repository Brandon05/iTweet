//
//  ProfileViewController.swift
//  iTweet
//
//  Created by Brandon Sanchez on 2/28/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import UIKit
import Kingfisher

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var screennameLabel: UILabel!
    @IBOutlet var profileImageOuterView: UIView!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var profileBannerImageView: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var timelineTableView: UITableView!
    @IBOutlet var followersCountLabel: UILabel!
    @IBOutlet var tweetsCountLabel: UILabel!
    @IBOutlet var followingCountLabel: UILabel!
    
    var user = User() {
        didSet {
            print(user.id!)
            getUser(withID: user.id!)
            getUserTimeline(forID: user.id!)
            //configureUser()
        }
    }
    
    var tweets = [Tweet]() {
        didSet {
            timelineTableView.reloadData()
        }
    }
    
    func configureUser() {
        self.profileBannerImageView.kf.indicatorType = .activity
        self.profileBannerImageView.kf.setImage(with: user.profileBannerUrl, options: [.transition(.fade(0.2))])
        nameLabel.text = user.name
        screennameLabel.text = "@\(user.screenname!)"
        setProfilePic(with: user.profileUrl!)
        descriptionLabel.text = user.tagline
        followersCountLabel.text = String(describing: user.followersCount!)
        followingCountLabel.text = String(describing: user.followingCount!)
        tweetsCountLabel.text = String(describing: user.tweetCount!)
    }
    
    func setProfilePic(with imageURL: URL) {
        profileImageOuterView.clipsToBounds = false
        profileImageOuterView.layer.shadowColor = UIColor.black.cgColor
        profileImageOuterView.layer.shadowOpacity = 0.38
        profileImageOuterView.layer.shadowOffset = CGSize.zero
        profileImageOuterView.layer.shadowRadius = 6
        profileImageOuterView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageOuterView.layer.shadowPath = UIBezierPath(roundedRect: profileImageOuterView.bounds, cornerRadius: profileImageOuterView.frame.width / 2).cgPath
        
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

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //TableView Settings
        timelineTableView.delegate = self
        timelineTableView.dataSource = self
        timelineTableView.register(TweetTableViewCell.self)
        self.automaticallyAdjustsScrollViewInsets = false
        self.timelineTableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        // Self-sizing magic!
        self.timelineTableView.rowHeight = UITableViewAutomaticDimension
        self.timelineTableView.estimatedRowHeight = 250

        
        configureUser()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

// Gesture Recognizer: Segue to Tweet Detail
extension ProfileViewController {
    // Long Press Target for actionView UILongPressGestureRecognizer
    func longPressGesture() -> UILongPressGestureRecognizer {
        let lpg = UILongPressGestureRecognizer(target: self, action: #selector(HomeTimelineViewController.longPress(_:)))
        lpg.minimumPressDuration = 0.2
        return lpg
    }
    
    func longPress(_ sender: UILongPressGestureRecognizer) {
        //print(sender.view)
        if sender.state == .began {
            self.performSegue(withIdentifier: "TweetDetailSegue", sender: sender.view)
        }
    }

}
