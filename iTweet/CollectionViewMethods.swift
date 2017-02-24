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
}
