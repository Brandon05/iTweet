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
    var timestampString: String
    var retweetCount: Int = 0
    var favoriteCount: Int = 0
    var user: User
    var displayURL: String?
    var id: Int
}

// Look into using computed values for some of these properties

extension Tweet {
    
    
    
    init?(dictionary: NSDictionary) {
    
    var displayURL = ""
        
        guard
        let text = dictionary["text"] as? String,
        let retweetCount = (dictionary["retweet_count"] as? Int),
        let favoriteCount = (dictionary["favorite_count"] as? Int),
        let timestampString = dictionary["created_at"] as? String,
        let id = dictionary["id"] as? Int,
        let userData = dictionary["user"] as? NSDictionary,
        let user = User(dictionary: userData)
//        let entities = dictionary["entities"] as! NSDictionary,
//        let urls = entities["urls"] as? [NSDictionary],
//        let displayURL = urls?[0]["expanded_url"] as! String
        else {
            return nil
        }
        
        // These can be nil, will break guard statement
        let entities = dictionary["entities"] as! NSDictionary
        let urls = entities["urls"] as? [NSDictionary]
        if urls?.count != 0 {
        displayURL = urls?[0]["expanded_url"] as! String
        }
        
        
        self.text = text
        self.retweetCount = retweetCount
        self.favoriteCount = favoriteCount
        self.user = user
        self.displayURL = displayURL
        self.id = id
        
        // Tweet TimeStamp
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        timestamp = formatter.date(from: timestampString)!
        
        // creating time stamp; days, hours, min, seconds
        let elapsedTime = NSDate().timeIntervalSince(timestamp)
        let duration = Int(elapsedTime)
        
        if duration / 86400 >= 1 {
            self.timestampString = String(duration / (360 * 24)) + "d"
        }
        else if duration / 3600 >= 1 {
            self.timestampString = String(duration / 360) + "h"
            
        }
        else if duration / 60 >= 1 {
            self.timestampString = String(duration / 60) + "min"
        }
        else {
            self.timestampString = String(duration) + "s"
        }
    }
    
    
}

/////////////////////
/// MARK:- Original code to check media url
/////////////////////

//    let userData = dictionary["user"] as? NSDictionary
//        //print(userData)
//
//    let user = User(dictionary: userData!)
//print(user)

//    let entities = dictionary["entities"] as! NSDictionary
//        //print(entities)
//        //print(entities["urls"])
//        for (key, value) in entities {
//            //print("\(key) & \(value)")
//        }

//    let urls = entities["urls"] as? [NSDictionary]
//print(urls)

//        if urls?.count != 0 {
//            //print(urls?.count)
//    if urls?[0] != nil {
//        ///print(urls?[0])
//        //print(urls?[0]["url"] as? String)
//    displayURL = urls?[0]["expanded_url"] as! String
//        //print(displayURL)
//        }
//        }
