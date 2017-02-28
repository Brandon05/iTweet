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
        let tweetCell = tableView.dequeueReusableCell(forIndexPath: indexPath) as TweetTableViewCell
        let tweet = tweets[indexPath.row]
        
//        let backgroundview =  TweetBackgroundView(frame: tweetCell.tweetBackgroundView.frame)
//        tweetCell.tweetBackgroundView.addSubview(backgroundview)
        
        
        tweetCell.setNeedsLayout()
        tweetCell.layoutIfNeeded()
        
        return tweetCell.bind(tweet)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let tweetCell = cell as? TweetTableViewCell
        
        let rectanglePath = UIBezierPath(roundedRect: CGRect(x: 5, y: 5, width: cell.frame.width - 10, height: cell.frame.height - 10), byRoundingCorners: [.topRight, .bottomLeft], cornerRadii: CGSize(width: 40, height: 40))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = cell.bounds
        maskLayer.path = rectanglePath.cgPath
        //cell.layer.masksToBounds = true
        //cell.layer.mask = maskLayer
        //tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        //tableView.reloadSections(indexPath, with: UITableViewRowAnimation.fade)
        //tweetCell?.tweetBackgroundView.applyMask()
        print(cell.subviews)
        cell.subviews[0].applyMask()
        //cell.contentView.applyMask()
        cell.layoutIfNeeded()
        cell.layoutSubviews()
    }
}
