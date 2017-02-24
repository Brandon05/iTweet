//
//  HomeTimelineViewController.swift
//  iTweet
//
//  Created by Brandon Sanchez on 2/13/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import UIKit

class HomeTimelineViewController: UIViewController {

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
                //print(tweets)
                self.tweets = tweets
                print(tweets[0].user)
            case .failure(let error):
                print(error)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
