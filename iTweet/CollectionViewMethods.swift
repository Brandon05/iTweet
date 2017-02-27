//
//  CollectionViewMethods.swift
//  iTweet
//
//  Created by Brandon Sanchez on 2/23/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import Foundation
import UIKit

extension HomeTimelineViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard tweets != nil else { return 1 }
        
        return tweets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tweetCell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as TweetCell
        let tweet = tweets[indexPath.row]
        
//        if UserDefaults.standard.value(forKey: String(describing: tweet.id) + "retweet") as? Bool == true {
//            tweetCell.retweetButton.normalColor = UIColor.red
//        }
//        if UserDefaults.standard.value(forKey: String(describing: tweet.id) + "like") as? Bool == true {
//            tweetCell.likeButton.normalColor = UIColor.red
//        }

        
        return tweetCell.bind(tweet)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as TweetCell
        
//        cell.addActionView()
//        cell.actionView.isHidden = false
//        print("here")
    }
}
