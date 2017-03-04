//
//  CollectionViewMethods.swift
//  iTweet
//
//  Created by Brandon Sanchez on 2/23/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import Foundation
import UIKit

extension HomeTimelineViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard tweets != nil else { return 1 }
        
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure cell and data
        let tweetCell = tableView.dequeueReusableCell(forIndexPath: indexPath) as TweetTableViewCell
        let tweet = tweets[indexPath.row]
        
        // Add targets to profile buttons
        tweetCell.profileButton.addTarget(self, action: #selector(HomeTimelineViewController.profileButtonsTapped(_:)), for: .touchUpInside)
        tweetCell.profileButton.tag = indexPath.row
        tweetCell.screennameButton.addTarget(self, action: #selector(HomeTimelineViewController.profileButtonsTapped(_:)), for: .touchUpInside)
        tweetCell.screennameButton.tag = indexPath.row
        
        // Add Targets for segue to TweetDetailViewController
        //tweetCell.actionView.addGestureRecognizer(longPress)
        tweetCell.tweetButtonOverlay.addGestureRecognizer(self.longPressGesture())
        tweetCell.tweetButtonOverlay.tag = indexPath.row
        
        // Configure webPreviewView if there is a link
//        handleWebPreview(for: tweetCell, and: tweet) { result in
//            switch result {
//            case .success(let data):
//                print("INDEX PATH: \(indexPath)")
//                print("urlLabel: \(tweetCell.urlLabel.text), mediaURLString: \(tweet.mediaUrlString)")
////                if tweetCell.urlLabel.text != tweet.mediaUrlString {
////                //tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
////                }
//            case .failure(let error):
//                print(error)
//            }
//            
//        }
        
        tweetCell.webViewButton.addGestureRecognizer(self.webViewTapGesture())
        tweetCell.webViewButton.tag = indexPath.row
        print(tweet.mediaImageUrl)
        
        return tweetCell.bind(tweet)
    }
    
    func handleWebPreview(for cell: TweetTableViewCell, and tweet: Tweet, completion: @escaping (Result<Any>) -> Void) {
        //print(tweet.displayURL)
        if tweet.displayURL == nil || tweet.displayURL == "" && cell.webPreviewView != nil {
            cell.webPreviewView.isHidden = true
            cell.tweetLabelBottom.constant = 6
            completion(Result.success("finished"))
        } else {
            cell.webPreviewView.isHidden = false
            cell.tweetLabelBottom.constant = 191.5
            setSwiftPreview(for: cell, withTweet: tweet) { result in
                switch result {
                    case .success(let data):
                    //tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                        cell.urlImageView.setNeedsDisplay()
                    completion(Result.success("finished"))
                    case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let tweetCell = cell as! TweetTableViewCell
        let tweet = tweets[indexPath.row]
        
        if tweet.mediaImageUrl != nil && tweetCell.urlImageView.image == nil {
            tweetCell.setNeedsDisplay()
        }
    }
}
