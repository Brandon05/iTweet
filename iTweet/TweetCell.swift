//
//  TweetCell.swift
//  iTweet
//
//  Created by Brandon Sanchez on 2/23/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import UIKit

class TweetCell: UICollectionViewCell {

    @IBOutlet var outerView: UIView!
    @IBOutlet var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func bind(_tweet: Tweet) {
        
    }
    
    func setProfilePic(with image: UIImage) {
        outerView.clipsToBounds = false
        outerView.layer.shadowColor = UIColor.black.cgColor
        outerView.layer.shadowOpacity = 0.38
        outerView.layer.shadowOffset = CGSize.zero
        outerView.layer.shadowRadius = 6
        outerView.layer.cornerRadius = profileImageView.frame.width / 2
        outerView.layer.shadowPath = UIBezierPath(roundedRect: outerView.bounds, cornerRadius: profileImageView.frame.width / 2).cgPath
        
        self.profileImageView.image = image
        profileImageView.contentMode = .scaleAspectFit
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
