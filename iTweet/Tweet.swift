//
//  Tweet.swift
//  iTweet
//
//  Created by Brandon Sanchez on 2/13/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import Foundation

struct Tweet {
    
    var text: String
    var timestamp: Date
    var retweetCount: Int = 0
    var favoriteCount: Int = 0
    var user: User
    
}

// Look into using computed values for some of these properties

extension Tweet {
    
    init?(dictionary: NSDictionary) {
        guard
        let text = dictionary["text"] as? String,
        let retweetCount = (dictionary["retweet_count"] as? Int),
        let favoriteCount = (dictionary["favorite_count"] as? Int),
        let timestampString = dictionary["created_at"] as? String,
        let user = dictionary["user"] as? NSDictionary
        else {
            return nil
        }
        
        self.text = text
        self.retweetCount = retweetCount
        self.favoriteCount = favoriteCount
        self.user = User(dictionary: user)!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        self.timestamp = formatter.date(from: timestampString)!
    }
    
    
}

extension Tweet {
    
//    func arrayFromTweets(dictionaries: [NSDictionary]) -> [Tweet] {
//        
//    }
}
