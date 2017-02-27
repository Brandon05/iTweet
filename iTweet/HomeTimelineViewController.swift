//
//  HomeTimelineViewController.swift
//  iTweet
//
//  Created by Brandon Sanchez on 2/13/17.
//  Copyright © 2017 Brandon Sanchez. All rights reserved.
//

import UIKit

class HomeTimelineViewController: UIViewController, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {

    @IBOutlet var timelineCollectionView: UICollectionView!
    
    var listFlowLayout = ListFlowLayout()
    var refreshControl: UIRefreshControl!
    
    var tweets = [Tweet]() {
        didSet {
            timelineCollectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // CollectionView Settings
        timelineCollectionView.delegate = self
        timelineCollectionView.dataSource = self
        self.automaticallyAdjustsScrollViewInsets = false
        timelineCollectionView.collectionViewLayout = listFlowLayout
        timelineCollectionView.register(TweetCell.self)
        
        
        if let flowLayout = timelineCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            //flowLayout.estimatedItemSize = CGSize(width: 200, height: 200)
        }
        
        //Refresh Control
        addRefreshControl()
        
        // Nav Bar
        configureNavBar()
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getCurrentTimeline()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onRefresh(refreshControl: UIRefreshControl) {
        getCurrentTimeline()
    }
    
    //MARK:- NavBar
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("yes")
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

extension HomeTimelineViewController {
    //MARK: - Configurations for HomeTimelineViewController
    
    func configureNavBar() {
        let titleImage = UIImageView(image: #imageLiteral(resourceName: "twitter_white"))
        let navigationBarHeight = navigationController?.navigationBar.frame.size.height
        let titleImageIconDimention = (navigationBarHeight ?? 44) * 0.75
        titleImage.frame = CGRect(x: 0, y: 0, width: titleImageIconDimention, height: titleImageIconDimention)
        titleImage.contentMode = UIViewContentMode.scaleAspectFit
        self.navigationItem.titleView = titleImage
    }
    
    func addRefreshControl() {
        // programatically adding pulltorefresh control, adjust color, call networkRequest()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(self.onRefresh(refreshControl:)), for: UIControlEvents.valueChanged)
        timelineCollectionView.insertSubview(refreshControl, at: 0)
        refreshControl.backgroundColor = UIColor.black.withAlphaComponent(0.8)//UIColor(hexString: "#63AEEB")
        refreshControl.tintColor = UIColor.white
    }
}
