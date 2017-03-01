//
//  CollectionViewMethods.swift
//  iTweet
//
//  Created by Brandon Sanchez on 2/23/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import Foundation
import UIKit

//extension HomeTimelineViewController: UICollectionViewDataSource, UICollectionViewDelegate {
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        guard tweets != nil else { return 1 }
//        
//        return tweets.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let tweetCell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as TweetCell
//        let tweet = tweets[indexPath.row]
//        
//        return tweetCell.bind(tweet)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as TweetCell
//        
//    }
//}

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
        handleWebPreview(for: tweetCell, and: tweet)
        
        return tweetCell.bind(tweet)
    }
    
    func handleWebPreview(for cell: TweetTableViewCell, and tweet: Tweet) {
        // if there is a url, set up Swift Preview
//        if tweet.displayURL != nil && tweet.displayURL != "" {
//            //self.contentView.addSubview(webPreviewView)
//            //setSwiftPreview(withTweet: tweet)
//            //addNib()
//        } else {
//            cell.webPreviewView.removeFromSuperview()
//            cell.tweetLabelBottom.constant = 6
//        }
        print(tweet.displayURL)
        if tweet.displayURL == nil || tweet.displayURL == "" && cell.webPreviewView != nil {
            //cell.webPreviewView.isHidden = true
            cell.webPreviewView.removeFromSuperview()
            cell.tweetLabelBottom.constant = 6
        } else {
            //cell.webPreviewView.isHidden = false
            //cell.addSubview(webPreviewView)
            //cell.tweetLabelBottom.constant = 191.5
        }
    }
    
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // Need to remove layer from reuseable cell or it will appear twice
        // TODO:- figure out how to manually remove and redraw layer on custom UIView: TweetBackgroundView
        //cell.subviews[0].layer.sublayers?[0].removeFromSuperlayer()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let tweetCell = cell as! TweetTableViewCell
        let tweet = tweets[indexPath.row]
        
        handleWebPreview(for: tweetCell, and: tweet)
        tweetCell.setNeedsUpdateConstraints()
        tweetCell.updateConstraints()
        
        // Need to add layer based on dynamic height
        // TODO:- figure out how to manually remove and redraw layer on custom UIView: TweetBackgroundView
        //print(cell.layer.sublayers)
        //cell.subviews[0].applyMask(withFrame: tweetCell.tweetBackgroundView.frame)
        //tweetCell.tweetBackgroundView.layer.sublayers?[0].removeFromSuperlayer()

    }
}
