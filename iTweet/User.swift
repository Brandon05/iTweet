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
    init(dictionary: NSDictionary) {
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        
        if let profileUrlString = dictionary["profile_image_url_https"] as? String {
            profileUrl = URL(string: profileUrlString)!
        }
        tagline = dictionary["name"] as? String
    }
}
