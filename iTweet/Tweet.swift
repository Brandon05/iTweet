//
//  Tweet.swift
//  iTweet
//
//  Created by Brandon Sanchez on 2/13/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import Foundation
import SwiftLinkPreview

class Tweet {
    
    var text: String = ""
    var timestamp: Date!
    var timestampString: String = ""
    var retweetCount: Int = 0
    var favoriteCount: Int = 0
    var user: User!
    var displayURL: String?
    var mediaImageUrl: URL?
    var mediaDescription: String?
    var mediaUrlString: String?
    //var media: Media?
    var id: Int = 0
    var entities: NSDictionary?
    var urls: [NSDictionary]?

// Look into using computed values for some of these properties
    
    
    init?(dictionary: NSDictionary) {
    
    var displayURL = ""
        var mediaImageUrl: URL? = nil
        var mediaDescription: String? = nil
        var mediaUrlString: String? = nil
        let linkPreview = SwiftLinkPreview()
        
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
        print(userData)
        // These can be nil, will break guard statement
        self.entities = dictionary["entities"] as! NSDictionary
        self.urls = entities?["urls"] as? [NSDictionary]
        if urls?.count != 0 {
        displayURL = urls?[0]["expanded_url"] as! String
            
            // submit a task to the queue for background execution
            DispatchQueue.global(qos: .background).async {
            linkPreview.preview(displayURL, onSuccess: { (result: [String : AnyObject]) in
                DispatchQueue.main.async {
                    
                    let images = result["images"] as? [String]
                    //print("IMAGES: - \((URL(string: images![0])!))")
                    if images?.count != 0 {
                        //print(images)
                        if let url = URL(string: images![0]) {
                        mediaImageUrl = url
                        }
                        //self.urlImageView.setImageWith(imageURL)
                        //            self.urlImageView.kf.indicatorType = .activity
                        //            self.urlImageView.kf.setImage(with: imageURL, options: [.transition(.fade(0.2))])
                        //self.urlImageView.af_setImage(withURL: imageURL)
                    }
                    mediaDescription = result["description"] as? String
                    mediaUrlString = result["url"] as? String
//                    print(mediaImageUrl)
//                    print(mediaDescription)
//                    print(mediaUrlString)
                    self.mediaImageUrl = mediaImageUrl
//                    self.mediaDescription = mediaDescription
//                    self.mediaUrlString = mediaUrlString
//                    self.text = text
//                    self.retweetCount = retweetCount
//                    self.favoriteCount = favoriteCount
//                    self.user = user
//                    self.displayURL = displayURL
//                    self.id = id
                    self.mediaImageUrl = mediaImageUrl
                    self.mediaDescription = mediaDescription
                    self.mediaUrlString = mediaUrlString
                }
            }, onError: { (error) in
                print(error)
            })
            }
        }
        
        self.text = text
        self.retweetCount = retweetCount
        self.favoriteCount = favoriteCount
        self.user = user
        self.displayURL = displayURL
        self.id = id
        self.mediaImageUrl = mediaImageUrl
        self.mediaDescription = mediaDescription
        self.mediaUrlString = mediaUrlString
        
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
    
    func setUpPreview(withLink link: String) {
        let linkPreview = SwiftLinkPreview()
        var mediaImageUrl: URL? = nil
        //let displayURL = urls?[0]["expanded_url"] as! String
        // submit a task to the queue for background execution
        DispatchQueue.global(qos: .background).async {
            linkPreview.preview(link, onSuccess: { (result: [String : AnyObject]) in
                DispatchQueue.main.async {
                    
                    let images = result["images"] as? [String]
                    //print("IMAGES: - \((URL(string: images![0])!))")
                    if images?.count != 0 {
                        mediaImageUrl = URL(string: images![0])!
                        //self.urlImageView.setImageWith(imageURL)
                        //            self.urlImageView.kf.indicatorType = .activity
                        //            self.urlImageView.kf.setImage(with: imageURL, options: [.transition(.fade(0.2))])
                        //self.urlImageView.af_setImage(withURL: imageURL)
                    }
                    let mediaDescription = result["description"] as? String
                    let mediaUrlString = result["url"] as? String
                    print(mediaImageUrl)
                    print(mediaDescription)
                    print(mediaUrlString)
                    self.mediaImageUrl = mediaImageUrl
//                    self.mediaDescription = mediaDescription
//                    self.mediaUrlString = mediaUrlString
                    //completion(Result.success(mediaImageUrl))
                }
            }, onError: { (error) in
                print(error)
            })
    }
    }
    
}


// Extension to download media:


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
