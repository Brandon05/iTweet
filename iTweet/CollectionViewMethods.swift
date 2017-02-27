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
        
        return tweetCell.bind(tweet)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as TweetCell
        
//        let baseView = UIView(frame: cell.frame)
//        baseView.frame = cell.contentView.bounds
//        let blurView = UIVisualEffectView(frame: cell.frame)
//        blurView.effect = UIVibrancyEffect(blurEffect: UIBlurEffect())
//        baseView.addSubview(blurView)
//        //cell.addSubview(baseView)
//        cell.contentView.addSubview(baseView)
//        
//        timelineCollectionView.performBatchUpdates({
//            self.timelineCollectionView.cellForItem(at: indexPath)
//        }) { (finished) in
//
//        }
//        cell.contentView.bringSubview(toFront: cell.actionView)
//        UIView.animate(withDuration: 0.3) { 
//            cell.actionView.alpha = 1
//        }
        //return cell
    }
}
