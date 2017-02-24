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
    var displayURL: URL?
}

// Look into using computed values for some of these properties

extension Tweet {
    
    
    
    init?(dictionary: NSDictionary) {
    let userData = dictionary["user"] as? NSDictionary
        print(userData)
        
    let user = User(dictionary: userData!)
        print(user)
       
    let entities = dictionary["entities"] as! NSDictionary
        print(entities)
        print(entities["urls"])
        for (key, value) in entities {
            print("\(key) & \(value)")
        }
        
    let urls = entities["urls"] as? [NSDictionary]
        print(urls)
    
    var displayURL = URL(string: "")
        if urls?.count != 0 {
            print(urls?.count)
    if urls?[0] != nil {
        print(urls?[0])
        print(urls?[0]["url"] as? String)
    displayURL = URL(string: (urls?[0]["url"] as? String)!)
        print(displayURL)
        }
        }
        
        guard
        let text = dictionary["text"] as? String,
        let retweetCount = (dictionary["retweet_count"] as? Int),
        let favoriteCount = (dictionary["favorite_count"] as? Int),
        let timestampString = dictionary["created_at"] as? String
//        let userData = dictionary["user"] as? NSDictionary,
//        let user = User(dictionary: userData),
//        let urls = dictionary["entities"] as? NSDictionary,
//        let entities = urls["urls"] as? NSDictionary,
//        let displayURL = URL(string: (entities["display_url"] as? String)!)
        else {
            return nil
        }
        
        
        self.text = text
        self.retweetCount = retweetCount
        self.favoriteCount = favoriteCount
        self.user = user!
        self.displayURL = displayURL
        
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
