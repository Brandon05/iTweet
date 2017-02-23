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
            let profileUrlString = dictionary["profile_image_url_https"] as? String,
            let tagline = dictionary["name"] as? String
        else {
            return nil
        }
        
        self.name = name
        self.screenname = screenname
        self.profileUrl = URL(string: profileUrlString)!
        self.tagline = tagline
    }

    static var currentUser: User?
}

extension User {
//    class Coding: NSObject, NSCoding {
//        let user: User?
//        
//        init(user: User?) {
//            self.user = user
//            super.init()
//        }
//        
//        required init?(coder aDecoder: NSCoder) {
//            guard let
//        }
//    }
}

/*
extension Event {
    class Coding: NSObject, NSCoding {
        let event: Event?
        
        init(event: Event) {
            self.event = event
            super.init()
        }
        
        required init?(coder aDecoder: NSCoder) {
            guard let timeStamp = aDecoder.decodeObject(forKey: "timeStamp") as? Date, let eventTag = aDecoder.decodeObject(forKey: "eventTag") as? String else {
                return nil
            }
            
            event = Event(timeStamp: timeStamp, tag: eventTag)
            
            super.init()
        }
        
        public func encode(with aCoder: NSCoder) {
            guard let event = event else {
                return
            }
            
            aCoder.encode(event.timeStamp, forKey: "timeStamp")
            aCoder.encode(event.eventTag, forKey: "eventTag")
        }
    }
}
 
*/
