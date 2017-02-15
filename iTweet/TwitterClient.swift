//
//  TwitterClient.swift
//  iTweet
//
//  Created by Brandon Sanchez on 2/13/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import Foundation
import BDBOAuth1Manager

enum Result<T> {
    case success(T)
    case failure(Error)
}

class TwitterClient {
    
    // Remove hard coding
    // persist keys in keychain?
    static let sharedInstance = BDBOAuth1SessionManager(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "M3MvlIFlGV1v3LOIOZL0ayIqn", consumerSecret: "elF0DUKx2ZhPpsSokF7zguocvvxVoRpAm5KQ8SmYRVuQ7MH2GC")
    
    class func getHomeTimeline(completion: @escaping (Result<[Tweet]>) -> Void) {
       let _ = TwitterClient.sharedInstance?.get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            
            guard let dictionaries = response as? [NSDictionary] else {return}
            
            // flatMap flattens and maps array of dictionaries
            let tweets = dictionaries.flatMap(Tweet.init)
         
            completion(Result.success(tweets))
            
        }, failure: { (task: URLSessionDataTask?, error: Error?) in
            
            completion(Result.failure(error!))
        })
    }
    
    class func authUser() {
        let _ = TwitterClient.sharedInstance?.get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            guard let userDictionary = response as? NSDictionary else {return}
            
            let user = User(dictionary: userDictionary)
            print(user)
            
        }, failure: { (task: URLSessionDataTask?, error: Error?) in
            
            print(error)
        })
    }
    
    class func login(completion: @escaping (Result<Any>) -> Void) {
        TwitterClient.sharedInstance?.deauthorize()
        
        TwitterClient.sharedInstance?.fetchRequestToken(withPath: "oauth/request_token", method: "GET", callbackURL: URL(string:"iTweet://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            
            guard let token = requestToken?.token else {return}
            print("https://api.twitter.com/oauth/authorize?oauth_token=\(token)")
            
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(token)")!
            
            // openURL was deprecated in iOS 10.0
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
            
            completion(Result.success("success"))
            
        }, failure: { (error: Error?) in
            completion(Result.failure(error!))
        })
    }
    
    class func handleOpenURL(_ url: URL) {
        print(url)
        
        var instance = BDBOAuth1SessionManager(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "M3MvlIFlGV1v3LOIOZL0ayIqn", consumerSecret: "elF0DUKx2ZhPpsSokF7zguocvvxVoRpAm5KQ8SmYRVuQ7MH2GC")
        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        TwitterClient.sharedInstance?.fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            
            print("ACCESS TOKEN: \(accessToken!.token)")
            TwitterClient.authUser()
        }, failure: { (error: Error?) in
            
            print("ERROR: \(error)")
        })
    
    }
}























