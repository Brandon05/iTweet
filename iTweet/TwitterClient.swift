//
//  TwitterClient.swift
//  iTweet
//
//  Created by Brandon Sanchez on 2/13/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import Foundation
import BDBOAuth1Manager
import SwiftLinkPreview

enum Result<T> {
    case success(T)
    case failure(Error)
}

/////////////////////////
/// MARK: - Shared Instance, Auth, and Login
/////////////////////////

class TwitterClient {
    
    // Using DispathGroup to notify end of login functions
    static let loginGroup = DispatchGroup()
    
    // Remove hard coding
    // persist keys in keychain?
    static let sharedInstance = BDBOAuth1SessionManager(baseURL: URL(string: "https://api.twitter.com")!, consumerKey: "M3MvlIFlGV1v3LOIOZL0ayIqn", consumerSecret: "elF0DUKx2ZhPpsSokF7zguocvvxVoRpAm5KQ8SmYRVuQ7MH2GC")
    
    // Optional completion block
    class func authUser(completion: @escaping (Result<User>) -> Void = { _ in }) {
        
        let _ = TwitterClient.sharedInstance?.get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            
            guard let userDictionary = response as? NSDictionary else {return}
            
            let user = User(dictionary: userDictionary)
            User.currentUser = user
            print(user)
            completion(Result.success(user!))
            
            // End of login chain
            //loginGroup.leave()
            
        }, failure: { (task: URLSessionDataTask?, error: Error?) in
            completion(Result.failure(error!))
            print(error)
        })
    }
    
    class func login(completion: @escaping (Result<Any>) -> Void) {
        TwitterClient.sharedInstance?.deauthorize()
        print(TwitterClient.sharedInstance?.isAuthorized)
        // Start of Login chain
        loginGroup.enter()
        
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
       
        // TO-DO: - handle crash when user cancels authorization
        // Works but I would like to handle it better !
        let queryString = String(describing: url.query)
        print(queryString)
        guard !queryString.contains("denied") else {return}

        
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        TwitterClient.sharedInstance?.fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            
            print("ACCESS TOKEN: \(accessToken!.token), SECRET: \(accessToken?.secret)")
            
            TwitterClient.authUser() { result in
                switch result {
                case .success:
                    loginGroup.leave()
                case .failure(let error):
                    print(error)
                }
            }
            
        }, failure: { (error: Error?) in
            
            print("ERROR: \(error)")
        })
    
    }
}


/////////////////////////
/// MARK: - Timeline Functions
/////////////////////////

extension TwitterClient {
    
    class func getHomeTimeline(completion: @escaping (Result<[Tweet]>) -> Void) {
        let _ = TwitterClient.sharedInstance?.get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionDataTask, response: Any?) -> Void in
            print(TwitterClient.sharedInstance?.isAuthorized)
            guard let dictionaries = response as? [NSDictionary] else {return}
            //print(dictionaries)
            // flatMap flattens and maps array of dictionaries
            //let tweets = dictionaries.flatMap {dict in (Tweet.init(dictionary: dict))}
            
            // Get web preview
            //let displayUrl = dictionaries.flatMap { return $0[""] }
            //setUpWebPreview(with: <#T##String#>, completion: <#T##(Result<NSMutableDictionary>) -> Void#>)
            
            // Initial array of tweets before web preview data
            let tweetArray = dictionaries.flatMap(Tweet.init)
            
            // Set up async web preview data
            setUpWebPreview(with: tweetArray, completion: { (result) in
                switch result {
                case .success(let tweets):
                    // Return new tweet array with web preview data
                    completion(Result.success(tweets))
                case .failure(let error):
                    completion(Result.failure(error))
                }
            })
            
            
            
        }, failure: { (task: URLSessionDataTask?, error: Error?) in
            
            completion(Result.failure(error!))
        })
    }
    
}

extension TwitterClient {
    class func setUpWebPreview(with tweetArray: [Tweet], completion: @escaping (Result<[Tweet]>) -> Void) {
        let linkPreview = SwiftLinkPreview()
        let mutableDictionary = [NSMutableDictionary]()
        var tweets = [Tweet]()
        
        for i in tweetArray {
            var tweet = i
        //if tweet.urls?.count != 0 {
            //tweet.displayURL = tweet.urls?[0]["expanded_url"] as! String
            print(tweet.displayURL)
        linkPreview.preview(tweet.displayURL, onSuccess: { (result: [String : AnyObject]) in
            DispatchQueue.main.async {
                
                let images = result["images"] as? [String]
                
                if images?.count != 0 {
                    tweet.mediaImageUrl = URL(string: images![0])!
                }
                tweet.mediaDescription = result["description"] as? String
                tweet.mediaUrlString = result["url"] as? String
                
                tweets.append(tweet)
                print(tweets.count)
                if tweets.count == 10 {
                completion(Result.success(tweets))
                }
            }
            
        }, onError: { (error) in
            print(error)
            completion(Result.failure(error))
        })
            
            
            
//        } else {
//            tweets.append(tweet)
//        }
            //completion(Result.success(tweets))
        }
        
        
    }
}

extension HomeTimelineViewController {
    
    // Network Request
    func getCurrentTimeline() {
        TwitterClient.getHomeTimeline { (timeline) in
            switch timeline {
            case .success(let tweets):
                print(tweets)
                self.tweets = tweets
                self.refreshControl.endRefreshing()
            //print(tweets[0].user)
            case .failure(let error):
                print(error)
            }
        }
    }
    
}


///////////////////////////////////
// MARK:- Retweet and Like Events
//////////////////////////////////

// Shrink into one func
extension TwitterClient {
    
    class func retweetTweet(withID id: Int) {
        
        let parameters = ["id" : id]
        
        let _ = TwitterClient.sharedInstance?.post("1.1/statuses/retweet/:id.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            if let responseJSON = response as? NSDictionary {
                print(responseJSON)
            } else {
                print(response)
            }
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print(error)
        })
        
    }
    
    class func likeTweet(withID id: Int) {
        
        let parameters = ["id" : id]
        
        let _ = TwitterClient.sharedInstance?.post("1.1/favorites/create.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            if let responseJSON = response as? NSDictionary {
                print(responseJSON)
            } else {
                print(response)
            }
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print(error)
        })
    }
    
    class func unretweetTweet(withID id: Int) {
        
        let parameters = ["id" : id]
        
        let _ = TwitterClient.sharedInstance?.post("1.1/statuses/unretweet/:id.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            if let responseJSON = response as? NSDictionary {
                print(responseJSON)
            } else {
                print(response)
            }
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print(error)
        })
        
    }
    
    class func unlikeTweet(withID id: Int) {
        
        let parameters = ["id" : id]
        
        let _ = TwitterClient.sharedInstance?.post("1.1/favorites/destroy.json", parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, response: Any?) in
            if let responseJSON = response as? NSDictionary {
                print(responseJSON)
            } else {
                print(response)
            }
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            print(error)
        })
    }
}





















