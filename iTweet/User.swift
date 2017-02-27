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
}

extension User {
    init?(dictionary: NSDictionary) {
        guard let name = dictionary["name"] as? String,
            let screenname = dictionary["screen_name"] as? String,
            let profileUrlStringSmall = dictionary["profile_image_url_https"] as? String,
            let tagline = dictionary["description"] as? String
        else {
            return nil
        }
        
        self.name = name
        self.screenname = screenname
        
        // returns larger images
        let profileUrlString = profileUrlStringSmall.replacingOccurrences(of: "_normal", with: "")
        self.profileUrl = URL(string: profileUrlString)!
        
        self.tagline = tagline
    }

    static var currentUser: User?
}
