//
//  HomeTimelineViewController.swift
//  iTweet
//
//  Created by Brandon Sanchez on 2/13/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import UIKit

class HomeTimelineViewController: UIViewController, UICollectionViewDelegateFlowLayout {

    @IBOutlet var timelineCollectionView: UICollectionView!
    
    var listFlowLayout = ListFlowLayout()
    
    var tweets = [Tweet]() {
        didSet {
            timelineCollectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        timelineCollectionView.delegate = self
        timelineCollectionView.dataSource = self
        self.automaticallyAdjustsScrollViewInsets = false
        timelineCollectionView.collectionViewLayout = listFlowLayout
        timelineCollectionView.register(TweetCell.self)
        
        
        if let flowLayout = timelineCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            //flowLayout.estimatedItemSize = CGSize(width: 200, height: 200)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getCurrentTimeline()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //TwitterClient.authUser()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func authUser(_ sender: Any) {
        //TwitterClient.authUser()
    }
    
    func getCurrentTimeline() {
        TwitterClient.getHomeTimeline { (timeline) in
            switch timeline {
            case .success(let tweets):
                print(tweets)
                self.tweets = tweets
                //print(tweets[0].user)
            case .failure(let error):
                print(error)
            }
        }
    }
    
//    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let cell = collectionView.cellForItem(at: indexPath)
//        
//        return CGSize(width: collectionView.frame.width - 6, height: 300)
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
