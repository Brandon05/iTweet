//
//  User.swift
//  iTweet
//
//  Created by Brandon Sanchez on 2/13/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import Foundation

struct User {
    var name: String?
    var screenname: String?
    var profileUrl: URL?
    var tagline: String?
    var id: Int?
    var followersCount: Int?
    var followingCount: Int?
    var tweetCount: String?
    var profileBannerUrl: URL?
}

extension User {
    init?(dictionary: NSDictionary) {
        guard let name = dictionary["name"] as? String,
            let screenname = dictionary["screen_name"] as? String,
            let profileUrlStringSmall = dictionary["profile_image_url_https"] as? String,
            let tagline = dictionary["description"] as? String,
            let id = dictionary["id"] as? Int,
            let followersCount = dictionary["followers_count"] as? Int,
            let followingCount = dictionary["friends_count"] as? Int,
            let tweetCount = dictionary["statuses_count"] as? Int,
            let profileBannerUrl = dictionary["profile_banner_url"] as? String
        else {
            return nil
        }
        
        self.name = name
        self.screenname = screenname
        self.id = id
        self.followersCount = followersCount
        self.followingCount = followingCount
        //self.tweetCount = tweetCount
        self.profileBannerUrl = URL(string: profileBannerUrl)!
        
        // returns larger images
        let profileUrlString = profileUrlStringSmall.replacingOccurrences(of: "_normal", with: "")
        self.profileUrl = URL(string: profileUrlString)!
        
        self.tagline = tagline
        
        let formatter = NumberFormatter()
        formatter.maximumSignificantDigits = 2
        //formatter.locale = NSLocale(localeIdentifier: "##.0")
        //formatter.decimalSeparator =
        self.tweetCount = formatter.string(from: NSNumber(value: tweetCount))
    }

    static var currentUser: User?
}
